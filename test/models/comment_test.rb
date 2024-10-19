# frozen_string_literal: true

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'courses are commentable' do
    course = Course.create
    user = User.create(email: 'hallo@mail.com', password: 'geheim12', password_confirmation: 'geheim12')
    course.comments.create(comment: 'bla bla', author: user)
    course.comments.create(comment: 'bla bla 2', author: user)
    assert_equal course.comments.size, 2
  end
end
