module JsonApiErrors
  extend ActiveSupport::Concern

  # ----------------------------------------------------------------------------------------------------
  # Error classes
  # ----------------------------------------------------------------------------------------------------

  class Error < StandardError
    attr_reader :error_code

    def initialize(msg = nil, error_code = nil)
      @error_code = error_code
      super(msg)
    end
  end

  class Unauthenticated < Error; end

  class MethodNotSupported < Error; end
end
