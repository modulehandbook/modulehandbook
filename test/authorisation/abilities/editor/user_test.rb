# frozen_string_literal: true

require 'test_helper'

class UserEditorAbilitiesTest < ActiveSupport::TestCase
  setup do
    @user = users(:editor)
    @user2 = users(:two)
    @ability = Ability.new(@user)
    # system_test_login(@user.email, 'geheim12')
  end

  test 'as editor i cant create a user' do
    assert @ability.cannot?(:create, @user2)
    assert @ability.cannot?(:new, @user2)
  end

  test 'as editor i can read a user' do
    assert @ability.can?(:read, @user2)
    assert @ability.can?(:show, @user2)
    assert @ability.can?(:index, @user2)
  end

  test 'as editor i cant edit and update a user' do
    assert @ability.cannot?(:edit, @user2)
    assert @ability.cannot?(:update, @user2)
  end

  test 'as editor i cant delete and destroy a user' do
    assert @ability.cannot?(:delete, @user2)
    assert @ability.cannot?(:destroy, @user2)
  end

  test 'as editor i can approve a user' do
    assert @ability.can?(:approve, @user2)
  end
end
