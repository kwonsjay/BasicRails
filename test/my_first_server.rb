require 'webrick'

server = WEBrick::HTTPServer.new :Port => 8080
root = '/'

#User my_proc to serve responses
server.mount_proc(root) do |request, response|
  response.content_type = "text/text"
  response.body = request.path
end

#Shutdown server cleanly
trap('INT') { server.shutdown }

#Start server
server.start
