require 'test_helper'

module AeNetworkConnectionException
  class AeNetworkConnectionExceptionTest < Minitest::Test
    def test_connection_not_established_exception
      # Exception Causes are standard with ruby 2.1
      # http://devblog.avdi.org/2013/12/25/exception-causes-in-ruby-2-1
      
      parent_exception = AeNetworkConnectionException::ConnectionNotEstablished.new("Parent Message")

      assert_equal nil, parent_exception.cause
      assert_equal "Parent Message", parent_exception.message

      begin
        child_exception = nil
        begin
          raise StandardError.new("New Child Message")
        rescue => e
          child_exception = e
          parent_exception = AeNetworkConnectionException::ConnectionNotEstablished.new("New Parent Message")
        end
      rescue AeNetworkConnectionException::ConnectionNotEstablished => parent_exception

        refute_nil child_exception
        assert_equal child_exception, parent_exception.cause
        assert_equal "New Parent Message, cause => StandardError: New Child Message", parent_exception.message
      end
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
      AeNetworkConnectionException.exception_signatures.each do |e|
        assert_connection_not_established_thrown_for(e)
      end
      
      assert_connection_not_established_not_thrown_for(Errno::ECONNRESET.new('Connection timed out - connect(2) for "example.com" port 443'))
      assert_connection_not_established_not_thrown_for(Errno::ETIMEDOUT.new('Connection timed out - recvfrom(2) for "example.com" port 443'))
    end
    
    def test_exception_signatures
      expected_signatures = [
        SocketError.new('getaddrinfo: Name or service not known'),
        Errno::ECONNREFUSED.new('Connection refused - connect(2) for "example.com" port 443'),
        Errno::ETIMEDOUT.new('Connection timed out - connect(2) for "example.com" port 443'),
        Net::OpenTimeout.new('message'),
        Errno::ECONNRESET.new('Connection reset by peer - SSL_connect')
      ]
      
      assert_equal expected_signatures.size, AeNetworkConnectionException.exception_signatures.size
      
      expected_signatures.each do |e|
        assert_includes AeNetworkConnectionException.exception_signatures, e 
      end
    end

    private
    
    def assert_connection_not_established_thrown_for(exception)
      e = return_raised_error do
        AeNetworkConnectionException.try do
          raise exception
        end
      end
      assert_equal AeNetworkConnectionException::ConnectionNotEstablished, e.class
      assert_equal exception, e.cause
    end
    
    def assert_connection_not_established_not_thrown_for(exception)
      e = return_raised_error do
        AeNetworkConnectionException.try do
          raise exception
        end
      end
      assert_equal exception, e
    end

    def return_raised_error
      yield
    rescue => e
      return e
    end
  end
end

