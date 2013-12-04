require 'json'
require 'webrick'

class Session
  def initialize(request)
    cookies = request.cookies.select { |cookie| cookie.name == '_rails_lite_app' }
    @cookie = cookies.empty? ? {} : JSON.parse(cookies.last.value)
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def store_session(response)
    new_cookie = WEBrick::Cookie.new('_rails_lite_app', JSON.generate(@cookie))
    response.cookies << new_cookie
  end
end
