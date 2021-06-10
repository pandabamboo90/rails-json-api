module Api
  module V1
    class AdminsController < AdminAuthController
      before_action :set_admin, only: [:show, :update, :destroy]

      # GET /admins
      def index
        @admins = Admin.where.not(id: current_user.id)
        # authorize! @admins, context: {user: current_user}
        authorize! @admins

        if admin_filter_params[:keyword].present?
          @admins = @admins.where("name LIKE :keyword", keyword: "%#{admin_filter_params[:keyword]}%")
            .or(Admin.where(email: admin_filter_params[:keyword]))
            .or(Admin.where(mobile_phone: admin_filter_params[:keyword]))
        end

        @admins = @admins.order(sort_params)
        @admins = paginate @admins
        options = SerializerOptions.new(request, @admins).build_options

        render json: AdminSerializer.new(@admins, options)
      end

      # GET /admins/1
      def show
        render json: AdminSerializer.new(@admin)
      end

      # POST /admins
      def create
        @admin = Admin.new
        @admin = update_admin_attributes(@admin)

        render json: AdminSerializer.new(@admin), status: :created
      end

      # PATCH/PUT /admins/1
      def update
        @admin = update_admin_attributes(@admin)

        render json: AdminSerializer.new(@admin), status: :ok
      end

      # ----------------------------------------------------------------------------------------------------
      # Private methods
      # ----------------------------------------------------------------------------------------------------

      private

      def update_admin_attributes(admin)
        return if admin.blank?

        ActiveRecord::Base.transaction do
          admin = assign_model_attributes(@admin, model_attributes: admin_attributes.except(:image))
          admin.image_data_uri = admin_attributes.dig(:image, :data) if admin_attributes.dig(:image, :data).present?
          admin.save!
        end

        admin
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_admin
        @admin = Admin.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def admin_params
        params.require(:data).permit(:type, {
          attributes: [:name, :email,
            :mobile_phone, :password, :locked,
            image: [:data, :url]]
        })
      end

      def admin_attributes
        admin_params[:attributes] || {}
      end

      def admin_filter_params
        params.permit(filter: [:keyword])
          .values
          .first
          .to_h
      end

      def sort_params
        default_sort_field = {created_at: :desc}
        sortable_fields = [:id, :name, :created_at, :email, :mobile_phone]

        SortParams.sorted_fields(params[:sort], sortable_fields, default_sort_field)
      end
    end
  end
end
