# This will register the mime type and the jsonapi and jsonapi_errors renderers.
require 'jsonapi'
JSONAPI::Rails.install!

# Sets the Oj as the Rails encoder and decoder
require "oj"
Oj.optimize_rails