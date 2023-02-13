require 'test_helper'

class VersionsAbilitiesTest <  ActiveSupport::TestCase
  setup do
    @course = courses(:one)
  end

roles = User::ROLES

roles = [:writer, :reader, :qa, :editor, :admin]
version_abilities = {
  :writer => { :can => [],
               :cannot => [:create, :read, :new, :show, :index, :delete, :update, :edit, :destroy]}
             }



  test 'tbd' do
    skip
    assert true
  end


end
