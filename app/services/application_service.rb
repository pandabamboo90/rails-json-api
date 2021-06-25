class ApplicationService
  include JSONAPI::Deserialization

  def self.call(*args, **kwargs, &block)
    #
    # Ruby 3 syntax for passing keyword arguments
    #
    # For more detail, check the below link
    # https://www.ruby-lang.org/en/news/2019/12/12/separation-of-positional-and-keyword-arguments-in-ruby-3-0/
    #
    new(*args, **kwargs, &block).call
  end
end
