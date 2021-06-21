module Api
  module V1
    class RolesController < AdminAuthController
      before_action :set_serializer_options, :set_serializer_klass
      # before_action :set_role, only: [:show, :update]

      # GET /roles
      def index
        @roles = Role.all
        authorize! @roles

        if role_filter_params[:keyword].present?
          @roles = @roles.where("name LIKE :keyword", keyword: "%#{role_filter_params[:keyword]}%")
                           .or(Role.where(email: role_filter_params[:keyword]))
                           .or(Role.where(mobile_phone: role_filter_params[:keyword]))
        end

        @roles = @roles.order(sort_params)
        @roles = paginate @roles
        options = SerializerOptions.new(request, @roles).build_options
        @serializer_options = @serializer_options.merge(options)

        render json: @serializer_klass.new(@roles, @serializer_options)
      end

      # GET /roles/1
      # def show
      #   render json: @serializer_klass.new(@role, @serializer_options)
      # end
      #
      # # POST /roles
      # def create
      #   @role = Role.new(jsonapi_deserialize(params, only: [:name, :mobile_phone, :email, :password]))
      #
      #   # Handle image upload
      #   image_data = params.dig(:data, :attributes, :image, :data)
      #   @role.image_data_uri = image_data if image_data.present?
      #
      #   @role.save!
      #
      #   render json: @serializer_klass.new(@role, @serializer_options)
      # end
      #
      # # PATCH/PUT /roles/1
      # def update
      #   @role.assign_attributes(jsonapi_deserialize(params, only: [:name]))
      #
      #   # Handle image upload
      #   image_data = params.dig(:data, :attributes, :image, :data)
      #   @role.image_data_uri = image_data if image_data.present?
      #
      #   # Update status lock/unlock
      #   param_locked = params.dig(:data, :attributes, :locked)
      #   param_locked.present? ? @role.lock : @role.unlock
      #
      #   @role.save!
      #
      #   render json: @serializer_klass.new(@role, @serializer_options)
      # end

      # ----------------------------------------------------------------------------------------------------
      # Private methods
      # ----------------------------------------------------------------------------------------------------

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_role
        @role = Role.find(params[:id])
        authorize! @role, to: :show?
      end

      def role_filter_params
        params.permit(filter: [:keyword])
              .values
              .first
              .to_h
      end

      def sort_params
        default_sort_field = { created_at: :desc }
        sortable_fields = [:id, :display_name, :name]

        SortParams.sorted_fields(params[:sort], sortable_fields, default_sort_field)
      end

      def set_serializer_klass
        @serializer_klass = RoleSerializer
      end

      def set_serializer_options
        @serializer_options = {}
        @serializer_options[:params] = {}
        @serializer_options[:meta] = {}
        @serializer_options[:include] = []
      end
    end
  end
end
