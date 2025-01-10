require "test_helper"

class TopicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @topic = topics(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get topics_url
    assert_response :success
  end

  # topics need to be created in the context of a program
  test "should get new" do
    @program = programs(:one)
    get new_topic_url(program_id: @program.id)
    assert_response :success
  end

  # topics need to be created in the context of a program and
  # together with the topic_description linking
  # program and topic
  # and be redirected to the program's topic tab
  test "should create topic" do
    @program = programs(:one)

    assert_difference("Topic.count") do
      post topics_url, params: { 
        topic: {
          title: @topic.title,
          topic_description: { description: "role of topic in program", 
                                implementable_id: @program.id,
                                implementable_type: 'Program'} }
    }
        
    end

    assert_redirected_to program_url(@program, tab: :topics)
  end

  test "should show topic" do
    get topic_url(@topic)
    assert_response :success
  end

  test "should get edit" do
    get edit_topic_url(@topic)
    assert_response :success
  end

  test "should update topic" do
    patch topic_url(@topic), params: { topic: { title: @topic.title } }
    assert_redirected_to topic_url(@topic)
  end

  test "should destroy topic" do
    assert_difference("Topic.count", -1) do
      delete topic_url(@topic)
    end

    assert_redirected_to topics_url
  end
end
