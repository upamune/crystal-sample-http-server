require "./crystal-sample-http-server/*"
require "http/server"
require "option_parser"

module Crystal::Sample::Http::Server
  port = 8080

  OptionParser.parse! do |parser|
    parser.on("-p PORT", "--port=PORT", "Specifies the port") { |port_str|
      port = port_str.to_i if port_str.to_i?
    }
  end

  server = HTTP::Server.new("0.0.0.0", port, [
    HTTP::ErrorHandler.new,
    HTTP::LogHandler.new,
  ]) do |context|
    case context.request.path
    when "/"
      context.response.content_type = "text/plain"
      context.response.status_code = 200
      context.response.print "Hello, Crystal."
    else
      context.response.status_code = 404
    end
  end

  puts "Listening on http://0.0.0.0:#{port}"
  server.listen
end
