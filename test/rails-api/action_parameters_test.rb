# frozen_string_literal: true

require 'test_helper'

class TryActionParameters < ActiveSupport::TestCase
  test 'define permitted params in an array' do
    permitted_params = %i[a c]
    params = ActionController::Parameters.new(a: '123', b: '456', c: 'asdf')
    params.permit(*permitted_params)
    assert_equal false, params.permitted?

    params2 = ActionController::Parameters.new(a: '123', c: 'asdf')
    params2 = params2.permit(permitted_params)
    assert_equal true, params2.permitted?
  end
end
