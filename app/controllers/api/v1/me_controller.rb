module Api
  module V1
    class MeController < MemberAuthController

      before_action :set_serializer_klass, :set_serializer_options

      # GET /me/profile
      def show
        render json: @serializer_klass.new(current_user, @serializer_options)

        # @serializer_klass = UserSerializer
        # render json: @serializer_klass.new(User.first, @serializer_options)
      end

      # PUt /me/profile
      def update
        if current_user.is_a?(Admin)
          @me = AdminServices::UpdateAdminService.call(admin: current_user, params: params)
        elsif current_user.is_a?(User)
          @me = AdminServices::UpdateAdminService.call(user: current_user, params: params)
        end

        render json: @serializer_klass.new(@me, @serializer_options)
      end

      # ----------------------------------------------------------------------------------------------------
      # Private methods
      # ----------------------------------------------------------------------------------------------------

      private

      def set_serializer_klass
        if current_user.is_a?(Admin)
          @serializer_klass = AdminSerializer
        elsif current_user.is_a?(User)
          @serializer_klass = UserSerializer
        end

        raise StandardError, "Not a valid resource Class to serialize" if @serializer_klass.blank?
      end

      def set_serializer_options
        @serializer_options = {}
        @serializer_options[:params] = {}
        @serializer_options[:meta] = {}
        @serializer_options[:include] = []

        if current_user.is_a?(User)
          @serializer_options[:include].push(:roles)
        end
      end
    end
  end
end
