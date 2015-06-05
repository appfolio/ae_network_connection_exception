require "ae_network_connection_exception/version"
require "socket"

module AeNetworkConnectionException
  
  class ConnectionNotEstablished < StandardError
    attr_reader :cause
    
    def initialize(message = nil, cause = $!)
      super(message)
      @cause = cause
    end

    def message
      own_message = super

      if cause
        message = "#{own_message}, "
        message + "cause => #{cause.class}: #{cause.message}"
      else
        own_message
      end
    end
  end

  def self.try
    yield
  rescue SocketError => e
    raise ConnectionNotEstablished
  rescue SystemCallError => e
    if ([Errno::ETIMEDOUT, Errno::ECONNREFUSED].include? e.class) && (e.message =~ /connect\(2\)/)
      raise ConnectionNotEstablished
    else
      raise e
    end
  end
end
