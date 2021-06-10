module Api
  module V1
    include AddressableConcern

    class StaffsController < MemberAuthController
      before_action :set_serializer_options, :set_location
      before_action :set_role, :set_address_attributes, only: [:create, :update]
      before_action :set_staff, only: [:show, :update]

      # GET /staffs
      def index
        @staffs = @location.staffs
        if user_is_staff?
          # Dont fetch the current staff record
          @staffs = @staffs.where.not(id: current_user.id)
        end

        authorize(@staffs, :index?, policy_class: StaffPolicy)

        if staff_filter_params[:keyword].present?
          @staffs = @staffs.where("staffs.name LIKE :keyword", keyword: "%#{staff_filter_params[:keyword]}%")
            .or(Staff.where(email: staff_filter_params[:keyword]))
            .or(Staff.where(mobile_phone: staff_filter_params[:keyword]))
        end

        if staff_filter_params[:locked].present?
          casted_param = ActiveModel::Type::Boolean.new.cast(staff_filter_params[:locked])
          @staffs = @staffs.locked(is_locked: casted_param)
        end

        if staff_filter_params[:role_id].present?
          @staffs = @staffs.where(role_id: staff_filter_params[:role_id])
        end

        if staff_filter_params[:role_ids].present?
          @staffs = @staffs.where(role_id: staff_filter_params[:role_ids].split(","))
        end

        if staff_filter_params[:available_service_id].present?
          @staffs = @staffs.eager_load(:location_services).where(
            location_services: {
              id: staff_filter_params[:available_service_id],
              locked_at: nil
            })
        end

        if staff_filter_params[:role_name].present?
          roles = @location.roles.where(name: staff_filter_params[:role_name].downcase)
          @staffs = @staffs.where(role_id: roles.ids)
        end

        @staffs = @staffs.order(sort_params)

        # no need build full data if get all
        if params.dig(:page, :size)&.downcase == "all"
          @serializer_options[:params] = {except_association: true}
        else
          @staffs = paginate @staffs
          options = SerializerOptions.new(request, @staffs).build_options
          @serializer_options = @serializer_options.merge(options)
        end

        render json: StaffSerializer.new(@staffs.includes(:role, staff_working_hours: :working_hour), @serializer_options)
      end

      # GET /staffs/:id
      def show
        update_serializer_options_for_technician if @staff.technician?

        render json: StaffSerializer.new(@staff, @serializer_options)
      end

      # POST /staffs
      def create
        ActiveRecord::Base.transaction do
          @staff = @location.staffs.new
          @staff = update_staff_attributes(staff: @staff)

          @staff.create_address!(@address_attributes) if @address_attributes.present?

          if @staff.technician?
            @staff.create_working_hours!(working_hours_params: working_hours_params) if working_hours_params.present?
            @staff.create_location_services!(location_services_params: location_services_params) if location_services_params.present?
            #
            # Update the technician_column for other techs
            #
            update_technician_column_attribute(staff: @staff, location: @location)

            update_serializer_options_for_technician
          end
        end

        render json: StaffSerializer.new(@staff, @serializer_options), status: :created
      end


      # PUT /staffs/:id
      def update
        ActiveRecord::Base.transaction do
          @staff = update_staff_attributes(staff: @staff)

          if @address_attributes.present?
            if @staff.address.present?
              @staff.address.update!(@address_attributes)
            else
              @staff.create_address!(@address_attributes)
            end
          end

          if @staff.technician?
            if working_hours_params.present?
              # cover old data will remove later
              not_yet_inserted = working_hours_params.filter { |wh| wh.dig(:id).blank? }
              inserted = working_hours_params.filter { |wh| wh.dig(:id).present? }
              @staff.staff_working_hours.create!(not_yet_inserted.pluck(:attributes))
              @staff.staff_working_hours.update(inserted.pluck(:id), inserted.pluck(:attributes)) if inserted.pluck(:attributes).compact.present?
            end

            if location_services_params.present?
              # Hack/fix:
              # Use the joins model to do the delete, fix the bug that cause data cannot fetch in serializer
              @staff.location_services.delete_all
              @staff.create_location_services!(location_services_params: location_services_params)
            end

            #
            # Update the technician_column for other techs
            #
            update_technician_column_attribute(staff: @staff, location: @location)

            update_serializer_options_for_technician
          end
        end

        render json: StaffSerializer.new(@staff, @serializer_options)
      end

      # ----------------------------------------------------------------------------------------------------
      # Private methods
      # ----------------------------------------------------------------------------------------------------

      private

      def location_services_params
        data = staff_params.dig(:relationships, :location_services, :data)
        return [] if data.blank?

        data.map { |item| item.permit(:id, :type) }
      end

      def working_hours_params
        data = staff_params.dig(:relationships, :staff_working_hours, :data)
        return [] if data.blank?

        data.map do |item|
          # Hack: No  update working_hour_id
          item[:attributes] = item[:attributes]&.except(:working_hour_id) if item.dig(:id).present?

          item.permit(:id, :type, attributes: [:from_time, :to_time, :working_hour_id, :available]).to_h
        end
      end

      def update_staff_attributes(staff:)
        return if staff.blank?

        staff.role = @role
        staff = assign_model_attributes(staff, model_attributes: staff_attributes.except(:image, :technician_column))
        staff.image_data_uri = staff_attributes.dig(:image, :data) if staff_attributes.dig(:image, :data).present?
        staff.save!

        staff
      end

      def update_technician_column_attribute(staff:, location:)
        new_technician_column_value = staff_attributes.dig(:technician_column)

        if staff.locked?
          # Shift technician_column value
          Staff.where("technician_column >= :technician_column", technician_column: staff.technician_column)
            .update_all("technician_column = technician_column - 1")

          #
          # Set the current tech column to nil
          staff.technician_column = nil
        elsif new_technician_column_value.present?
          return if new_technician_column_value == staff.technician_column

          #
          # In case the current staff doesn't have technician_column value,
          # set it to maximum value
          if staff.technician_column.blank?
            staff.set_technician_column_to_max
          end

          # Do swap position of 2 being effected records
          swapping_staff = location.staffs.find_by!(technician_column: new_technician_column_value)
          swapping_staff.technician_column = staff.technician_column
          swapping_staff.save!

          staff.technician_column = new_technician_column_value
        # Early return if technician_column wasn't change
        else
          # In case the user is restored after being deactivated, and no "technician_column" present,
          # set it to maximum value
          staff.set_technician_column_to_max
        end

        staff.save!
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_address_attributes
        @address_attributes = AddressableConcern.address_attributes(staff_params, :address)
      end

      def set_role
        role_param = staff_params
          .require(:relationships)
          .require(:role)
          .require(:data)

        @role = @location.roles.find_by("id = :role_id OR name = :role_name",
          role_id: role_param.dig(:id),
          role_name: role_param.dig(:attributes, :name))
        # TODO: Should add RolePolicy here
      end

      def set_staff
        @staff = @location.staffs.find(params[:id])

        authorize(@staff, :show?, policy_class: StaffPolicy)
      end

      def set_serializer_options
        @serializer_options = {}
        @serializer_options[:include] = [:role, :address, :staff_working_hours]
      end

      def update_serializer_options_for_technician
        @serializer_options[:include].push(:staff_working_hours, :location_services, "location_services.category")
      end

      # Only allow a trusted parameter "white list" through.
      def staff_params
        params.require(:data).permit(
          :type,
          {
            attributes: [:name, :display_name, :code, :gender, :email,
              :image, :mobile_phone, :password, :locked, :technician_column,
              :ticket_payment_ratio, :same_location_operation,
              image: [:data, :url],
              payment_configs: [:frequency, :method, :estimated_bonus, :tip_included, :ratio, :bonus_ratio_percent]]
          },
          relationships: {
            role: {},
            address: {},
            location_services: {},
            staff_working_hours: {}
          }
        )
      end

      def staff_attributes
        staff_params[:attributes] || {}
      end

      def staff_filter_params
        params.permit(filter: [:keyword, :role_id, :role_ids, :role_name, :available_service_id, :locked])
          .values
          .first
          .to_h
      end

      def sort_params
        default_sort_field = {created_at: :desc}
        sortable_fields = [:id, :name, :gender, :created_at, :email, :mobile_phone, :technician_column]

        SortParams.sorted_fields(params[:sort], sortable_fields, default_sort_field)
      end
    end
  end
end
