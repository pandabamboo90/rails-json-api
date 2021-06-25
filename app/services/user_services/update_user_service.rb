module UserServices
  class UpdateUserService < ApplicationService
    attr_reader :user, :params

    def initialize(user:, params:)
      @user = user
      @params = params
    end

    def call
      User.transaction do
        @user.assign_attributes(jsonapi_deserialize(params, only: [:name, :mobile_phone]))

        # Handle image upload
        image_data = params.dig(:data, :attributes, :image, :data)
        @user.image_data_uri = image_data if image_data.present?

        # Update status lock/unlock
        param_locked = params.dig(:data, :attributes, :locked)
        param_locked.present? ? @user.lock : @user.unlock

        # Handle user's roles
        @user.roles.delete_all # Clean all current roles
        relationships_data = jsonapi_deserialize(params, only: [:roles])
        @user.roles << Role.where(id: relationships_data.dig("role_ids"))

        @user.save!
      end


      # Return
      @user
    end
  end
end
