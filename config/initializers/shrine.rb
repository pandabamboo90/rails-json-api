require "shrine"
require "shrine/storage/file_system"
require "shrine/storage/s3"

s3_options = {
  bucket: Rails.application.credentials.dig(:s3, :bucket), # required
  access_key_id: Rails.application.credentials.dig(:s3, :access_key_id),
  secret_access_key: Rails.application.credentials.dig(:s3, :secret_access_key),
  region: Rails.application.credentials.dig(:s3, :region),
}

Shrine.storages = if Rails.env.development? || Rails.env.test?
  {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads") # permanent
  }
else
  {
    cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options), # temporary
    store: Shrine::Storage::S3.new(**s3_options) # permanent
  }
end

Shrine.plugin :activerecord # loads Active Record integration
Shrine.plugin :cached_attachment_data # enables retaining cached file across form redisplays
Shrine.plugin :restore_cached_data # extracts metadata for assigned cached files
Shrine.plugin :validation_helpers # validate file
Shrine.plugin :remove_invalid # remove and delete files that failed validation
