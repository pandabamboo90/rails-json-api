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
end
