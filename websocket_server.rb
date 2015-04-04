require 'digest/sha1'
require 'base64'
require 'socket'
require_relative 'websocket_connection'

class WebsocketServer
  
  attr_accessor :connections

  def initialize(options={path: '/', port: 4567, host: 'localhost'})
    @path, port, host = options[:path], options[:port], options[:host]
    @tcp_server = TCPServer.new(host, port)
    @connections = []
  end

  def broadcast(message)
    connections.each do |connection|
      connection.send("Received #{message}. Thanks!")
    end
  end

  def connect(&block)
    loop do
      Thread.start(@tcp_server.accept) do |socket|
          connection = WebsocketConnection.new(socket, @path)
          if connection.handshake
            connections << connection
            yield(connection)
          end
      end
    end
  end

end