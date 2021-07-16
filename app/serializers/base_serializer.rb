class BaseSerializer
  include JSONAPI::Serializer

  def self.image_attribute(record:)
    return nil if record.image.blank?

    {
      thumbnail: record.image_url(:thumbnail),
      url: record.image.url
    }
  end

  def self.format_time(time:)
    time&.strftime('%H:%M')
  end

  def self.param_include_has_key?(params:, key:)
    params.dig(:include)&.include?(key) || false
  end
end
