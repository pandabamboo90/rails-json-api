module Api
  module V1
    class UsersController < MemberAuthController
      before_action :set_serializer_options, :set_serializer_klass
      before_action :set_user, except: [:index]

      # GET /users
      def index
        @users = User.where.not(id: current_user.id)
        authorize! @users

        if user_filter_params[:keyword].present?
          @users = @users.where("name LIKE :keyword", keyword: "%#{user_filter_params[:keyword]}%")
                           .or(User.where(email: user_filter_params[:keyword]))
                           .or(User.where(mobile_phone: user_filter_params[:keyword]))
        end

        @users = @users.order(sort_params)
        @users = paginate @users
        options = SerializerOptions.new(request, @users).build_options
        @serializer_options = @serializer_options.merge(options)

        render json: @serializer_klass.new(@users, @serializer_options)
      end

      # GET /users/1
      def show
        render json: @serializer_klass.new(@user, @serializer_options)
      end

      # POST /users
      def create
        @user = User.new(jsonapi_deserialize(params, only: [:name, :mobile_phone, :email, :password]))

        # Handle image upload
        image_data = params.dig(:data, :attributes, :image, :data)
        @user.image_data_uri = image_data if image_data.present?

        @user.save!

        render json: @serializer_klass.new(@user, @serializer_options)
      end

      # PATCH/PUT /users/1
      def update
        @user.assign_attributes(jsonapi_deserialize(params, only: [:name]))

        # Handle image upload
        image_data = params.dig(:data, :attributes, :image, :data)
        @user.image_data_uri = image_data if image_data.present?

        # Update status lock/unlock
        param_locked = params.dig(:data, :attributes, :locked)
        param_locked.present? ? @user.lock : @user.unlock

        @user.save!

        render json: @serializer_klass.new(@user, @serializer_options)
      end

      # DELETE /users/1
      def destroy
        @user.discard
        @serializer_options[:meta] = { message: 'User destroyed !'}

        render json: @serializer_klass.new(@user, @serializer_options)
      end

      # PUT /users/1/restore
      def restore
        @user.undiscard
        @serializer_options[:meta] = { message: 'User restored !'}

        render json: @serializer_klass.new(@user, @serializer_options)
      end

      # ----------------------------------------------------------------------------------------------------
      # Private methods
      # ----------------------------------------------------------------------------------------------------

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
        authorize! @user, to: :show?
      end

      def user_filter_params
        params.permit(filter: [:keyword])
              .values
              .first
              .to_h
      end

      def sort_params
        default_sort_field = { created_at: :desc }
        sortable_fields = [:id, :name, :created_at, :email, :mobile_phone]

        SortParams.sorted_fields(params[:sort], sortable_fields, default_sort_field)
      end

      def set_serializer_klass
        @serializer_klass = UserSerializer
      end

      def set_serializer_options
        @serializer_options = {}
        @serializer_options[:params] = {}
        @serializer_options[:meta] = {}
        @serializer_options[:include] = [:roles]
      end
    end
  end
end
