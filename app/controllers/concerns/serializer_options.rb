class SerializerOptions
  attr_reader :options

  def initialize(request, collection, options = {})
    @request = request
    @collection = collection
    @options = options
  end

  def build_options
    build_meta_obj
    build_links_obj

    @options
  end

  def build_meta_obj
    @options[:meta] = {
      page: @collection.current_page,
      per_page: @collection.per_page,
      total: @collection.total_entries
    }

    @options
  end

  def build_links_obj
    url = @request.base_url + @request.path_info
    @options[:links] = {}

    pages_obj = ApiPagination.pages_from(@collection)
    pages_obj = pages_obj.merge({ self: @collection.current_page.to_i })

    pages_obj.each do |k, v|
      new_request_params = @request.query_parameters.clone
      if new_request_params[:page].blank?
        new_request_params[:page] = {
          number: v
        }
      else
        new_request_params[:page][:number] = v
      end

      @options[:links][k] = %(<#{url}?#{URI.decode_www_form_component(new_request_params.to_param)}>; rel="#{k}")
    end

    @options
  end
end
