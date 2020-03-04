# frozen_string_literal: true

require 'net/http'
require 'socket'

module AeNetworkConnectionException
  class ConnectionNotEstablished < StandardError
  end

  class << self
    def try
      yield
    rescue SocketError, Net::OpenTimeout, *other_exceptions
      # SocketError happens when we fail to connect to a socket.
      # Common problems here are DNS resolution (i.e. getaddrinfo).
      # Net::OpenTimeout happens when we are unable to establish an HTTP connection before the open_timeout.
      raise ConnectionNotEstablished
    rescue Errno::ETIMEDOUT, Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ENETUNREACH => e
      # Errno::ECONNREFUSED happens when we can not connect to the port.
      # Errno::ETIMEDOUT happens when we timeout durring the tcp handshake.
      # Errno::ETIMEDOUT can also happen after we have established a connection and are waiting for a response.
      # Because of this, we also check that the sys call that was made is connect(2).
      # Errno::* Exceptions have the following error message format:
      #   "#{Message string} - #{syscall} for "#{host}" port #{port}"
      raise_if_exception_message_matches(e, /connect\(2\)/)
    rescue Errno::ECONNRESET => e
      # Errno::ECONNRESET happens when the connection is reset. This can happen during SSL negotiation.
      raise_if_exception_message_matches(e, /SSL_connect/)
    end

    # An array of examples for all the exceptions that we will catch
    def exception_signatures
      [
        SocketError.new('getaddrinfo: Name or service not known'),
        Errno::ECONNREFUSED.new('Connection refused - connect(2) for "example.com" port 443'),
        Errno::ETIMEDOUT.new('Connection timed out - connect(2) for "example.com" port 443'),
        Net::OpenTimeout.new('message'),
        Errno::ECONNRESET.new('Connection reset by peer - SSL_connect'),
        Errno::EHOSTUNREACH.new('No route to host - connect(2) for "example.com" port 443'),
        Errno::ENETUNREACH.new('Network is unreachable - connect(2) for "example.com" port 443')
      ]
    end

    private

    def other_exceptions
      defined?(RestClient::Exceptions::OpenTimeout) ? [RestClient::Exceptions::OpenTimeout] : []
    end

    def raise_if_exception_message_matches(exception, pattern)
      raise ConnectionNotEstablished if exception.message =~ pattern

      raise exception
    end
  end
end
