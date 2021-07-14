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
        unless params.dig(:page, :size)&.downcase == "all"
          @roles = paginate @roles
          options = SerializerOptions.new(request, @roles).build_options
          @serializer_options = @serializer_options.merge(options)
        end

        render json: @serializer_klass.new(@roles, @serializer_options)
      end

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

      def include_params
        allowed_fields = [:permissions]

        IncludeParams.include_fields(params[:include], allowed_fields)
      end

      def set_serializer_klass
        @serializer_klass = RoleSerializer
      end

      def set_serializer_options
        @serializer_options = {}
        @serializer_options[:params] = {}
        @serializer_options[:meta] = {}
        @serializer_options[:include] = [] + include_params
      end
    end
  end
end
