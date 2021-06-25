module AdminServices
  class UpdateAdminService < ApplicationService
    attr_reader :admin, :params

    def initialize(admin:, params:)
      @admin = admin
      @params = params
    end

    def call
      Admin.transaction do
        @admin.assign_attributes(jsonapi_deserialize(params, only: [:name]))

        # Handle image upload
        image_data = params.dig(:data, :attributes, :image, :data)
        @admin.image_data_uri = image_data if image_data.present?

        # Update status lock/unlock
        param_locked = params.dig(:data, :attributes, :locked)
        param_locked.present? ? @admin.lock : @admin.unlock

        @admin.save!
      end


      # Return
      @admin
    end
  end
end
