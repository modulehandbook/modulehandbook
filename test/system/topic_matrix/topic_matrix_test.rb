require "application_system_test_case"

class TopicMatrixTest < ApplicationSystemTestCase
  setup do

    @program = programs(:one)
    @topic = topics(:one)
    @user = users(:one)
    system_test_login(@user.email, 'geheim12')
  end

  test 'create new topic for program' do
    visit program_url(@program, tab: :topics)
    # https://github.com/teamcapybara/capybara#clicking-links-and-buttons
    #assert_equal "", Capybara.default_selector
    click_link('new_topic')
    fill_in('topic_title', with: 'A Topic Title')
    fill_in('topic_topic_description_description', with: 'A Topic Description for Program')
    find_button(name: 'commit').click
    assert_text 'Topic and Topic Description was successfully created.'
    assert_text 'A Topic Title'
    assert_text 'A Topic Description for Program'


  end
end