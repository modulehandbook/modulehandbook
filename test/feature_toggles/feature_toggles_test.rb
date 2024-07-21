require 'test_helper'

class FeatureToggleTest < ActionView::TestCase

  test "lehreinsatzplanungsparser" do
    assert_equal true, Rails.configuration.feature['lehreinsatzplanung']
  end
  
end
