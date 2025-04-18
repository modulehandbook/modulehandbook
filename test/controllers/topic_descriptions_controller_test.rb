require "test_helper"

class TopicDescriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @topic_description = topic_descriptions(:one)
    sign_in users(:one)
  end

  # topic_descriptions need to be created from courses
  # for a specific topic
  #  /topic_descriptions/new/:topic_id/:course_id(.:format)
  test "should get new" do
    @topic = topics(:one)
    @course = courses(:one)
    get new_topic_description_url(topic_id: @topic, course_id: @course)
    assert_response :success
  end

  test "should create topic_description for program" do
    @program = programs(:plain)
    @topic = topics(:plain)
    assert_difference("TopicDescription.count") do
      post topic_descriptions_url, params: {
        #back_to:
        topic_description: {
          description: @topic_description.description,
          implementable_id: @program.id,
          implementable_type: @program.class,
          topic_id: @topic_description.topic_id } }
    end
    created = TopicDescription.last
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
    patch topic_description_url(@topic_description), params: { topic_description: { description: @topic_description.description, implementable_id: @topic_description.implementable_id, implementable_type: @topic_description.implementable_type, topic_id: @topic_description.topic_id } }
    assert_redirected_to topic_description_url(@topic_description)
  end

  test "should destroy topic_description" do
    @program_id = @topic_description.topic.topic_descriptions.first.implementable_id
    
    assert_difference("TopicDescription.count", -1) do
      delete topic_description_url(@topic_description)
    end

    assert_redirected_to program_url(@program_id , tab: :topics_for_courses)
  end
end
