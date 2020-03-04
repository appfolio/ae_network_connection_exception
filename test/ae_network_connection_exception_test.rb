# frozen_string_literal: true

require 'test_helper'

module AeNetworkConnectionException
  class AeNetworkConnectionExceptionTest < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::AeNetworkConnectionException::VERSION
    end

    def test_connection_not_established_exception
      parent_exception = AeNetworkConnectionException::ConnectionNotEstablished.new('Parent Message')

      assert_nil parent_exception.cause
      assert_equal 'Parent Message', parent_exception.message

      begin
        child_exception = nil
        begin
          raise StandardError, 'New Child Message'
        rescue StandardError => e
          child_exception = e
          AeNetworkConnectionException::ConnectionNotEstablished.new('New Parent Message')
        end
      rescue AeNetworkConnectionException::ConnectionNotEstablished => e
        refute_nil child_exception
        assert_equal child_exception, e.cause
        assert_equal 'New Parent Message, cause => StandardError: New Child Message', e.message
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

      econnreset = Errno::ECONNRESET.new('Connection timed out - connect(2) for "example.com" port 443')
      assert_connection_not_established_not_thrown_for(econnreset)
      etimeout = Errno::ETIMEDOUT.new('Connection timed out - recvfrom(2) for "example.com" port 443')
      assert_connection_not_established_not_thrown_for(etimeout)
    end

    def test_ae_network_connection_exception_try__raises_connection_not_establised_exception_rest_client_open_timeout
      open_timeout = RestClient::Exceptions::OpenTimeout.new
      assert_connection_not_established_thrown_for(open_timeout)
    end

    def test_exception_signatures
      assert_equal expected_signatures.size, AeNetworkConnectionException.exception_signatures.size

      expected_signatures.each do |e|
        assert_includes AeNetworkConnectionException.exception_signatures, e
      end
    end

    def test_rest_client_not_defined
      old = RestClient::Exceptions::OpenTimeout
      RestClient::Exceptions.send(:remove_const, :OpenTimeout)

      assert_empty AeNetworkConnectionException.send(:other_exceptions)
    ensure
      RestClient::Exceptions.const_set(:OpenTimeout, old)
    end

    private

    def expected_signatures
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
    rescue StandardError => e
      e
    end
  end
end
