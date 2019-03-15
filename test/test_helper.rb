require 'rubygems'
require 'minitest/autorun'
require 'ae_network_connection_exception'

private

class Minitest::Test
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
