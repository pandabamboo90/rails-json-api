module Api
  module V1
    class PermissionsController < AdminAuthController
      before_action :set_serializer_options, :set_serializer_klass

      # GET /permissions
      def index
        @permissions = Permission.all
        authorize! @permissions

        render json: @serializer_klass.new(@permissions, @serializer_options)
      end

      # ----------------------------------------------------------------------------------------------------
      # Private methods
      # ----------------------------------------------------------------------------------------------------

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_serializer_klass
        @serializer_klass = PermissionSerializer
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
