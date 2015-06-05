require 'test_helper'

module AeNetworkConnectionException
  class AeNetworkConnectionExceptionTest < Test::Unit::TestCase
    def test_connection_not_established_exception
      parent_exception = AeNetworkConnectionException::ConnectionNotEstablished.new("Parent Message")

      assert_equal nil, parent_exception.cause
      assert_equal "Parent Message", parent_exception.message

      child_exception = StandardError.new("Child Message")
      parent_exception = AeNetworkConnectionException::ConnectionNotEstablished.new("Parent Message", child_exception)

      assert_equal child_exception, parent_exception.cause
      assert_equal "Parent Message, cause => StandardError: Child Message", parent_exception.message

      child_exception = nil
      parent_exception = nil
      begin
        raise StandardError.new("New Child Message")
      rescue => e
        child_exception = e
        parent_exception = AeNetworkConnectionException::ConnectionNotEstablished.new("New Parent Message")
      end

      assert_not_nil child_exception
      assert_equal child_exception, parent_exception.cause
      assert_equal "New Parent Message, cause => StandardError: New Child Message", parent_exception.message
    end

    def test_ae_network_connection_exception_try__doesnt_catch_non_network_exceptions
      exception = StandardError.new
      e = return_raised_error do
        AeNetworkConnectionException.try do
          raise exception
        end
      end
      assert_equal exception, e
    end
    
    def test_ae_network_connection_exception_try__raises_connection_not_establised_exception
      e = return_raised_error do
        AeNetworkConnectionException.try do
          raise SocketError.new("getaddrinfo: Name or service not known")
        end
      end
      assert_equal AeNetworkConnectionException::ConnectionNotEstablished, e.class
      assert_equal SocketError, e.cause.class
      
      e = return_raised_error do
        AeNetworkConnectionException.try do
          raise Errno::ECONNREFUSED.new('Connection refused - connect(2) for "example.com" port 443')
        end
      end
      assert_equal AeNetworkConnectionException::ConnectionNotEstablished, e.class
      assert_equal Errno::ECONNREFUSED, e.cause.class
      
      e = return_raised_error do
        AeNetworkConnectionException.try do
          raise Errno::ETIMEDOUT.new('Connection timed out - connect(2) for "example.com" port 443')
        end
      end
      assert_equal AeNetworkConnectionException::ConnectionNotEstablished, e.class
      assert_equal Errno::ETIMEDOUT, e.cause.class
      
      

      e = return_raised_error do
        AeNetworkConnectionException.try do
          raise Errno::ECONNRESET.new('Connection timed out - connect(2) for "example.com" port 443')
        end
      end
      assert_equal Errno::ECONNRESET, e.class
      
      e = return_raised_error do
        AeNetworkConnectionException.try do
          raise Errno::ETIMEDOUT.new('Connection timed out - recvfrom(2) for "example.com" port 443')
        end
      end
      assert_equal Errno::ETIMEDOUT, e.class
      
    end

    private

    def return_raised_error
      yield
    rescue => e
      return e
    end
  end
end

