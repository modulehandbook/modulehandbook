class TopicDescriptionsController < ApplicationController
  load_and_authorize_resource

  # GET /topic_descriptions or /topic_descriptions.json
  def index
    @topic_descriptions = TopicDescription.all
  end

  # GET /topic_descriptions/1 or /topic_descriptions/1.json
  def show
  end

  # GET /topic_descriptions/new
  def new
    @topic_description = TopicDescription.new
  end

  # GET /topic_descriptions/1/edit
  def edit
  end

  # POST /topic_descriptions or /topic_descriptions.json
  def create
    @topic_description = TopicDescription.new(topic_description_params)

    respond_to do |format|
      if @topic_description.save
        format.html { redirect_to topic_description_url(@topic_description), notice: "Topic description was successfully created." }
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
      if @topic_description.update(topic_description_params)
        format.html { redirect_to topic_description_url(@topic_description), notice: "Topic description was successfully updated." }
        format.json { render :show, status: :ok, location: @topic_description }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @topic_description.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topic_descriptions/1 or /topic_descriptions/1.json
  def destroy
    @topic_description.destroy!

    respond_to do |format|
      format.html { redirect_to topic_descriptions_url, notice: "Topic description was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def topic_description_params
      params.require(:topic_description).permit(:topic_id, :implementable_id, :implementable_type, :description)
    end
end
