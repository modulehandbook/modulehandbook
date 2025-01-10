require "application_system_test_case"

class TopicMatrixSystemTest < ApplicationSystemTestCase
  include AccessControlHelper::LinkHelper
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
    _path, id = path_and_id_for_new('topic', program_id: @program.id)

    click_link(id)
    fill_in('topic_title', with: 'A Topic Title')
    fill_in('topic_topic_description_description', with: 'A Topic Description for Program')
    find_button(name: 'commit').click
    assert_text 'Topic and Topic Description were successfully created.'
    assert_text 'A Topic Title'
    assert_text 'A Topic Description for Program'

  end


  test 'add topic description for course' do

    @td = topic_descriptions(:new_topic_in_program)
    @program = @td.implementable
    @topic = @td.topic
    @course = @program.courses.first

    visit program_url(@program, tab: :topics)
    path_after_creation = program_path(@program.id, tab: :topics)
    path_args = {course_id: @course.id, topic_id: @topic.id, back_to: path_after_creation}
    _path, id = path_and_id_for_new('topic_description', path_args)
    click_link(id)
    desc = 'A Topic Description for Course'
    fill_in('topic_description_description', with: desc)
    find_button(name: 'commit').click
    assert_text 'Topic description was successfully created.'
    # assert_current_path does not contain get parameter
    path_after_creation_without_params = path_after_creation.gsub(/\?.*/,'')
    assert_current_path(path_after_creation)
    #assert_current_path(path_after_creation_without_params)
    assert_text desc
    assert_text 'New topic'
  end


end