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
    # socket error happens when we fail to connect to a socket. Common problems here are DNS resolution (i.e. getaddrinfo)
    
    raise ConnectionNotEstablished
  rescue SystemCallError => e
    # Errno::ECONNREFUSED happens when we can not connect to the port
    # Errno::ETIMEDOUT happens when we timeout durring the tcp handshake
    # It is important to note, Errno::ETIMEDOUT can also happen after we have established a connection and are waiting for a response.
    # Because of this, we also check that the sys call that was made is connect(2).
    # Errno::* Exceptions have the following error message format
    # "#{Message string} - #{syscall} for "#{host}" port #{port}"
    
    if ([Errno::ETIMEDOUT, Errno::ECONNREFUSED].include? e.class) && (e.message =~ /connect\(2\)/)
      raise ConnectionNotEstablished
    else
      raise e
    end
  end
end
