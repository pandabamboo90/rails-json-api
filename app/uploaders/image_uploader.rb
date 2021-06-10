require "image_processing/mini_magick"

class ImageUploader < Shrine
  # Plugins
  plugin :url_options, store: { 
    host: Rails.application.credentials.dig(:s3, :cdn_url),
    public: true
  }
  plugin :remove_invalid
  plugin :data_uri # Allow upload base64 data URI
  plugin :infer_extension # For detect the file extension from data URI content
  plugin :pretty_location
  plugin :derivatives, create_on_promote: true
  plugin :default_url

  Attacher.validate do
    validate_mime_type %w[image/jpeg image/png image/gif]
    validate_extension %w[jpg jpeg png gif]
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      thumbnail:  magick.resize_to_limit!(167, 121),
    }
  end

  Attacher.default_url do |derivative: nil, **|
    file&.url if derivative
  end
end
