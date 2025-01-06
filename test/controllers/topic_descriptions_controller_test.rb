require "test_helper"

class TopicDescriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @topic_description = topic_descriptions(:one)
  end

  test "should get index" do
    get topic_descriptions_url
    assert_response :success
  end

  test "should get new" do
    get new_topic_description_url
    assert_response :success
  end

  test "should create topic_description" do
    assert_difference("TopicDescription.count") do
      post topic_descriptions_url, params: { topic_description: { description: @topic_description.description, implementer_id: @topic_description.implementer_id, implementer_type: @topic_description.implementer_type, topic_id: @topic_description.topic_id } }
    end

    assert_redirected_to topic_description_url(TopicDescription.last)
  end

  test "should show topic_description" do
    get topic_description_url(@topic_description)
    assert_response :success
  end

  test "should get edit" do
    get edit_topic_description_url(@topic_description)
    assert_response :success
  end

  test "should update topic_description" do
    patch topic_description_url(@topic_description), params: { topic_description: { description: @topic_description.description, implementer_id: @topic_description.implementer_id, implementer_type: @topic_description.implementer_type, topic_id: @topic_description.topic_id } }
    assert_redirected_to topic_description_url(@topic_description)
  end

  test "should destroy topic_description" do
    assert_difference("TopicDescription.count", -1) do
      delete topic_description_url(@topic_description)
    end

    assert_redirected_to topic_descriptions_url
  end
end
