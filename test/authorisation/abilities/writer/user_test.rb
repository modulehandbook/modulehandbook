# frozen_string_literal: true

require 'application_system_test_case'

class UserWriterAbilitiesTest < ApplicationSystemTestCase
  setup do
    @user = users(:writer)
    @user1 = users(:one)
    @user2 = users(:two)
    @ability = Ability.new(@user)
    # system_test_login(@user.email, 'geheim12')
  end

  test 'as writer i cant create a user' do
    assert @ability.cannot?(:create, @user2)
    assert @ability.cannot?(:new, @user2)
  end

  test 'as writer i can read a readable user' do
    assert @ability.can?(:read, @user1)
    assert @ability.can?(:show, @user1)
    assert @ability.can?(:index, @user1)
  end

  test 'as writer i cant edit and update a user' do
    assert @ability.cannot?(:edit, @user2)
    assert @ability.cannot?(:update, @user2)
  end

  test 'as writer i cant delete and destroy a user' do
    assert @ability.cannot?(:delete, @user2)
    assert @ability.cannot?(:destroy, @user2)
  end

  test 'as writer i cant approve a user' do
    assert @ability.cannot?(:approve, @user2)
  end
end
