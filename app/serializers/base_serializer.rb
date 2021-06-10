class BaseSerializer
  include FastJsonapi::ObjectSerializer

  def self.image_attribute(model)
    if model.image&.exists?
      {
        url: model.image_url(:thumbnail)
      }
    end
  end

  def self.format_time(time:)
    time&.strftime('%H:%M')
  end
end
