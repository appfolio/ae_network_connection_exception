require "ae_network_connection_exception/version"
require "net/http"
require "socket"

module AeNetworkConnectionException
  class ConnectionNotEstablished < StandardError
  end

  OTHER_EXCEPTIONS = []
  if defined?(RestClient::Exceptions::OpenTimeout)
    OTHER_EXCEPTIONS << RestClient::Exceptions::OpenTimeout
  end
  OTHER_EXCEPTIONS.freeze

  class << self
    def try
      yield
    rescue SocketError, Net::OpenTimeout, *OTHER_EXCEPTIONS => e
      # SocketError happens when we fail to connect to a socket. Common problems here are DNS resolution (i.e. getaddrinfo)
      # Net::OpenTimeout happens when we are unable to establish an HTTP connection before the open_timeout

      raise ConnectionNotEstablished
    rescue Errno::ETIMEDOUT, Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ENETUNREACH => e
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

    # An array of examples for all the exceptions that we will catch
    def exception_signatures
      [
        SocketError.new('getaddrinfo: Name or service not known'),
        Errno::ECONNREFUSED.new('Connection refused - connect(2) for "example.com" port 443'),
        Errno::ETIMEDOUT.new('Connection timed out - connect(2) for "example.com" port 443'),
        Net::OpenTimeout.new('message'),
        Errno::ECONNRESET.new('Connection reset by peer - SSL_connect', Errno::ECONNREFUSED.new('Connection refused - connect(2) for "example.com" port 443')),
        Errno::EHOSTUNREACH.new('No route to host - connect(2) for "example.com" port 443'),
        Errno::ENETUNREACH.new('Network is unreachable - connect(2) for "example.com" port 443')
      ]
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
