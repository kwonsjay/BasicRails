require 'uri'

class Params
  def initialize(request)#, route_params)
    query = request.query_string || request.body
    @params = query.nil? ? {} : parse_www_encoded_form(query)
    # @route_params = route_params
  end

  def [](key)
    @params.each do |param|
      param[key] if param.has_key?(key)
    end
  end

  def to_s
    JSON.generate(@params)
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    parsed = {}
    URI.decode_www_form(www_encoded_form).each do |tuple|
      keys = parse_key(tuple.first)
      value = tuple.last
      pointer = parsed
      keys.each_with_index do |key, index|
        if pointer[key]
          pointer = pointer[key]
          next
        else
          pointer[key] = nest_hash(keys[(index + 1)..-1], value)
          pointer = pointer[key]
        end
      end
    end
    parsed
  end
  
  
  def nest_hash(keys, value)
    if keys.empty?
      value
    else
      { keys.shift => nest_hash(keys, value) }
    end
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
