# frozen_string_literal: true

require 'test_helper'

class UserAdminAbilitiesTest <  ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @user2 = users(:two)
    @ability = Ability.new(@user)
    # system_test_login(@user.email, 'geheim12')
  end

  test 'as admin i can create a user' do
    assert @ability.can?(:create, @user2)
    assert @ability.can?(:new, @user2)
  end

  test 'as admin i can read a user' do
    assert @ability.can?(:read, @user2)
    assert @ability.can?(:show, @user2)
    assert @ability.can?(:index, @user2)
  end

  test 'as admin i can edit and update a user' do
    assert @ability.can?(:edit, @user2)
    assert @ability.can?(:update, @user2)
  end

  test 'as admin i can delete and destroy a user' do
    assert @ability.can?(:delete, @user2)
    assert @ability.can?(:destroy, @user2)
  end

  test 'as admin i can approve a user' do
    assert @ability.can?(:approve, @user2)
  end
end
