class TopicDescriptionsController < ApplicationController
  load_and_authorize_resource

  # GET /topic_descriptions or /topic_descriptions.json
  def index
    @topic_descriptions = TopicDescription.all.select{|td| td.implementable.class == Program}.uniq
    @programs = @topic_descriptions.map(&:implementable).uniq


    # TopicDescription.all.map(&:implementable)
    # TopicDescription.where(implementable_type: Program).map(&:implementable)
    # TopicDescription.where(implementable_type: Course).map(&:implementable)

  end

  # GET /topic_descriptions/1 or /topic_descriptions/1.json
  def show
    @comments = @topic_description.comments
    @comments_size = @comments.size
    @comment = @topic_description.comments.build(author: @current_user)
  end

  # GET /topic_descriptions/new
  def new
    @topic = Topic.find(params[:topic_id])
    @course = Course.find(params[:course_id])
    @implementable_id = @course.id
    @implementable_type = @course.class
    @topic_description = TopicDescription.new(implementable: @course, topic: @topic)
  end

  # GET /topic_descriptions/1/edit
  def edit
    @topic = @topic_description.topic
    @implementable = @topic_description.implementable
    @implementable_type = @topic_description.implementable_type
    @implementable_id = @topic_description.implementable_id
  end

  # POST /topic_descriptions or /topic_descriptions.json
  def create
    @topic_description = TopicDescription.new(topic_description_params)
    respond_to do |format|
      if @topic_description.save
        back_to_path = @back_to_path || topic_description_url(@topic_description)
        format.html { redirect_to back_to_path,
                                  notice: "Topic description was successfully created.",
                                  allow_other_host: false }
        format.json { render :show, status: :created, location: @topic_description }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @topic_description.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topic_descriptions/1 or /topic_descriptions/1.json
  def update

    respond_to do |format|
      back_to_path = @back_to_path || topic_description_url(@topic_description)
      if @topic_description.update(topic_description_params)
        format.html { redirect_to back_to_path,
                                  notice: "Topic description was successfully updated.",
                                  allow_other_host: false }
        format.json { render :show, status: :ok, location: @topic_description }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @topic_description.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topic_descriptions/1 or /topic_descriptions/1.json
  def destroy
    @program_id = @topic_description.topic.topic_descriptions.first.implementable_id  
    @topic_description.destroy!

    respond_to do |format|
      format.html { redirect_to program_path(@program_id, tab: :topics_for_courses), notice: "Topic description was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def topic_description_params
      params.require(:topic_description).permit(:topic_id, :implementable_id, :implementable_type, :description)
    end
end
