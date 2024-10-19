require 'minitest/autorun'

class NameTest < Minitest::Test
  def test_this_is_my_name
    assert_equal('test_this_is_my_name', name)
  end
end

class TestOrder2 < ActiveSupport::TestCase
  test 'a name with a block' do
    assert_equal('test_a_name_with_a_block', name)
  end
end
