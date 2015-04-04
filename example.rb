require_relative 'websocket_server'

server = WebsocketServer.new

server.connect do |connection|

	connection.listen do |message|
    puts "Received #{message}"
		connection.send("Received #{message}. Thanks, yo!")
	end

end