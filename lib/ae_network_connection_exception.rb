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

  class << self
    def try
      yield
    rescue SocketError, Net::OpenTimeout => e
      # SocketError happens when we fail to connect to a socket. Common problems here are DNS resolution (i.e. getaddrinfo)
      # Net::OpenTimeout happens when we are unable to establish an HTTP connection before the open_timeout

      raise ConnectionNotEstablished
    rescue Errno::ETIMEDOUT, Errno::ECONNREFUSED => e
      # Errno::ECONNREFUSED happens when we can not connect to the port
      # Errno::ETIMEDOUT happens when we timeout durring the tcp handshake
      # It is important to note, Errno::ETIMEDOUT can also happen after we have established a connection and are waiting for a response.
      # Because of this, we also check that the sys call that was made is connect(2).
      # Errno::* Exceptions have the following error message format
      # "#{Message string} - #{syscall} for "#{host}" port #{port}"

      raise_if_exception_message_matches(e, /connect\(2\)/)
    rescue Errno::ECONNRESET => e
      # Errno::ECONNRESET happens when the connection is reset. This can happen during ssl negotiation
      
      raise_if_exception_message_matches(e, /SSL_connect/)
    end
    
    private
    
    def raise_if_exception_message_matches(exception, pattern)
      if exception.message =~ pattern
        raise ConnectionNotEstablished
      else
        raise exception
      end
    end
  end
end
