require "application_system_test_case"

class TopicsTest < ApplicationSystemTestCase
  setup do
    @topic = topics(:one)
    @user = users(:one)
    system_test_login(@user.email, 'geheim12')
  end

  test "visiting the index" do
    visit topics_url
    assert_selector "h1", text: "Topics"
  end

  # todo: rewrite to start from program
  test "should create topic" do
    skip
    visit topics_url
    click_on "New topic"

    fill_in "Title", with: @topic.title
    click_on "Create Topic"

    assert_text "Topic was successfully created"
    click_on "Back"
  end

  test "should update Topic" do
    visit topic_url(@topic)
    click_on "Edit this topic", match: :first

    fill_in "Title", with: @topic.title
    click_on "Update Topic"

    assert_text "Topic was successfully updated"
    click_on "Back"
  end

  test "should destroy Topic" do
    visit topic_url(@topic)
    click_on "Destroy this topic", match: :first

    assert_text "Topic was successfully destroyed"
  end
end
