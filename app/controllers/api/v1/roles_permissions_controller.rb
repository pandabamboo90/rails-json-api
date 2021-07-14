module Api
  module V1
    class RolesPermissionsController < AdminAuthController
      before_action :set_serializer_options, :set_serializer_klass

      # GET /roles_permissions
      def index
        @records = fetch_roles_permissions_records

        render json: @serializer_klass.new(@records, @serializer_options)
      end

      # PUT /roles_permissions
      def update
        RolePermission.transaction do
          params.require(:data).each do |item|
            attributes = jsonapi_deserialize({ data: item.as_json }, only: [:role_id, :permission_id, :status])
                           .to_hash
                           .with_indifferent_access

            record = RolePermission.find_or_initialize_by(attributes.except(:status))

            attributes.dig(:status).present? ? record.save! : record.destroy!
          end
        end

        @records = fetch_roles_permissions_records

        render json: @serializer_klass.new(@records, @serializer_options)
      end

      # ----------------------------------------------------------------------------------------------------
      # Private methods
      # ----------------------------------------------------------------------------------------------------

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_serializer_klass
        @serializer_klass = RolePermissionSerializer
      end

      def set_serializer_options
        @serializer_options = {}
        @serializer_options[:params] = {}
        @serializer_options[:meta] = {}
        @serializer_options[:include] = []
      end

      def fetch_roles_permissions_records
        records = RolePermission.all.order(:role_id, :permission_id)
        authorize! records

        # Return
        records
      end
    end
  end
end
