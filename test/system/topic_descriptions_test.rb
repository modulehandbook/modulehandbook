require "application_system_test_case"

class TopicDescriptionsTest < ApplicationSystemTestCase
  setup do
    @topic_description = topic_descriptions(:one)
  end

  test "visiting the index" do
    visit topic_descriptions_url
    assert_selector "h1", text: "Topic descriptions"
  end

  test "should create topic description" do
    visit topic_descriptions_url
    click_on "New topic description"

    fill_in "Description", with: @topic_description.description
    fill_in "Implementer", with: @topic_description.implementer_id
    fill_in "Implementer type", with: @topic_description.implementer_type
    fill_in "Topic", with: @topic_description.topic_id
    click_on "Create Topic description"

    assert_text "Topic description was successfully created"
    click_on "Back"
  end

  test "should update Topic description" do
    visit topic_description_url(@topic_description)
    click_on "Edit this topic description", match: :first

    fill_in "Description", with: @topic_description.description
    fill_in "Implementer", with: @topic_description.implementer_id
    fill_in "Implementer type", with: @topic_description.implementer_type
    fill_in "Topic", with: @topic_description.topic_id
    click_on "Update Topic description"

    assert_text "Topic description was successfully updated"
    click_on "Back"
  end

  test "should destroy Topic description" do
    visit topic_description_url(@topic_description)
    click_on "Destroy this topic description", match: :first

    assert_text "Topic description was successfully destroyed"
  end
end
