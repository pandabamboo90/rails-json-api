module Api
  module V1
    class AdminsController < AdminAuthController
      before_action :set_serializer_options, :set_serializer_klass
      before_action :set_admin, only: [:show, :update]

      # GET /admins
      def index
        @admins = Admin.where.not(id: current_user.id)
        authorize! @admins

        if admin_filter_params[:keyword].present?
          @admins = @admins.where("name LIKE :keyword", keyword: "%#{admin_filter_params[:keyword]}%")
                           .or(Admin.where(email: admin_filter_params[:keyword]))
                           .or(Admin.where(mobile_phone: admin_filter_params[:keyword]))
        end

        @admins = @admins.order(sort_params)
        @admins = paginate @admins
        options = SerializerOptions.new(request, @admins).build_options
        @serializer_options = @serializer_options.merge(options)

        render json: @serializer_klass.new(@admins, @serializer_options)
      end

      # GET /admins/1
      def show
        render json: @serializer_klass.new(@admin, @serializer_options)
      end

      # POST /admins
      def create
        @admin = Admin.new(jsonapi_deserialize(params, only: [:name, :mobile_phone, :email, :password]))

        # Handle image upload
        image_data = params.dig(:data, :attributes, :image, :data)
        @admin.image_data_uri = image_data if image_data.present?

        @admin.save!

        render json: @serializer_klass.new(@admin, @serializer_options)
      end

      # PATCH/PUT /admins/1
      def update
        @admin.assign_attributes(jsonapi_deserialize(params, only: [:name]))

        # Handle image upload
        image_data = params.dig(:data, :attributes, :image, :data)
        @admin.image_data_uri = image_data if image_data.present?

        # Update status lock/unlock
        param_locked = params.dig(:data, :attributes, :locked)
        param_locked.present? ? @admin.lock : @admin.unlock

        @admin.save!

        render json: @serializer_klass.new(@admin, @serializer_options)
      end

      # ----------------------------------------------------------------------------------------------------
      # Private methods
      # ----------------------------------------------------------------------------------------------------

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_admin
        @admin = Admin.find(params[:id])
        authorize! @admin, to: :show?
      end

      def admin_filter_params
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
        @serializer_klass = AdminSerializer
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
