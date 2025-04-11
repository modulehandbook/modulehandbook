
# frozen_string_literal: true

require 'test_helper'

class TopicMatrixIntegrationTest < ActionDispatch::IntegrationTest

  setup do
    @topic = topics(:one)
    sign_in users(:one)
  end

   test "should update topic_description for course" do
     @program = programs(:topic_matrix_program)
     @topic_description = topic_descriptions(:topic_matrix_description_course)
     @course = @topic_description.implementable
     @topic = @topic_description.topic
     updated_description = 'The text of the updated Topic Description'
     back_to_path =  program_path(@program, tab: :topics)
     patch topic_description_url(@topic_description), params:
       { back_to: back_to_path,
         topic_description: {
           description: updated_description,
           implementable_id: @topic_description.implementable_id,
           implementable_type: @topic_description.implementable_type,
           topic_id: @topic_description.topic_id },
        }

     # Reload article to refresh data and assert that title is updated.
     assert_redirected_to back_to_path

     @topic_description.reload
     assert_equal updated_description, @topic_description.description


   end

end