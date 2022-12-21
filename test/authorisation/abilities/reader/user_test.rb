# frozen_string_literal: true

require 'test_helper'

class UserReaderAbilitiesTest <  ActiveSupport::TestCase
  setup do
    @reader = users(:reader)
    @user1 = users(:one)
    @user2 = users(:two)
    @ability = Ability.new(@reader)
    # system_test_login(@reader.email, 'geheim12')
  end

  test 'as reader i cant create a user' do
    assert @ability.cannot?(:create, @user2)
    assert @ability.cannot?(:new, @user2)
  end

  test 'as reader i can read own user object' do
    assert @ability.can?(:read, @reader)
    assert @ability.can?(:show, @reader)
    assert @ability.can?(:index, @reader)
  end

  test 'as reader i cant read other users with readable false' do
    assert @ability.cannot?(:read, @user2)
    assert @ability.cannot?(:show, @user2)
    assert @ability.cannot?(:index, @user2)
  end

  test 'as reader i can read other users with readable true' do
    assert @ability.can(:read, @user1)
    assert @ability.can(:show, @user1)
    assert @ability.can(:index, @user1)
  end

  test 'as reader i cant edit and update a user' do
    assert @ability.cannot?(:edit, @user2)
    assert @ability.cannot?(:update, @user2)
  end

  test 'as reader i cant delete and destroy a user' do
    assert @ability.cannot?(:delete, @user2)
    assert @ability.cannot?(:destroy, @user2)
  end

  test 'as reader i cant approve a user' do
    assert @ability.cannot?(:approve, @user2)
  end
end
