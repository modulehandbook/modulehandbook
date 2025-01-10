class TopicsController < ApplicationController

  load_and_authorize_resource

  # GET /topics or /topics.json
  def index
    @topics = Topic.all
  end

  # GET /topics/1 or /topics/1.json
  def show
  end

  # GET /topics/new
  # new topics are always generated from a program together with the linking topic_description
  def new
    @topic = Topic.new
    @program = Program.find(params[:program_id])
    @topic_description = TopicDescription.new(implementable: @program, topic: @topic)
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics or /topics.json
  def create

    @topic = Topic.new(topic_params)
    tdp = topic_description_params.merge(topic: @topic)
    @topic_description = TopicDescription.new(tdp)

    respond_to do |format|
      if @topic.save && @topic_description.save
        @program = @topic_description.implementable
        format.html { redirect_to program_url(@program, tab: :topics), notice: "Topic and Topic Description were successfully created." }
        format.json { render :show, status: :created, location: @topic_description }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @topic_description.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1 or /topics/1.json
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to topic_url(@topic), notice: "Topic was successfully updated." }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1 or /topics/1.json
  def destroy
    @topic.destroy!

    respond_to do |format|
      format.html { redirect_to topics_url, notice: "Topic was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def topic_params
      params.require(:topic).permit(:title, :topic_description)
    end

  def topic_description_params
    params.require(:topic).require(:topic_description).permit(:description, :implementable_id, :implementable_type)
  end
end
