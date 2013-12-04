require 'erb'
require_relative 'params'
require_relative 'session'
require 'active_support/core_ext'

class ControllerBase
  attr_reader :params

  def initialize(request, response)#, route_params)
    @request = request
    @response = response
    session
    set_params
  end

  def session
    @session ||= Session.new(@request)
  end
  
  def set_params
    @params ||= Params.new(@request)
  end

  def already_rendered?
  end

  def redirect_to(url)
    @response.status = 302
    @response["location"] = url
    @already_built_response = true
    @session.store_session(@response)
  end

  def render_content(body, content_type)
    @response.content_type = content_type
    @response.body = body
    @already_built_response = true
    @session.store_session(@response)
  end

  def render(template_name)
    controller_name = self.class.name.underscore
    content = File.read("views/#{controller_name}/#{template_name}.html.erb")
    template = ERB.new(content).result(binding)
    render_content(template, "text/text")
  end

  def invoke_action(name)
  end
end