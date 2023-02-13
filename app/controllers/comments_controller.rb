class CommentsController < ApplicationController
  include VersioningHelper

  load_and_authorize_resource

  def show; end
  def create

    @comment = Comment.new(comment_params)

    if @comment.save
      redirect_to request.referrer, notice: 'Comment saved successfully'
    else
      redirect_to request.referrer, error: 'Error saving comment'
    end
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to course_path(@comment.course),
                  anchor: 'comments',
                  notice: 'Comment was successfully updated.'
    else
      redirect_to course_path(@comment.course),
                  anchor: 'comments',
                  notice: 'Error updating comment'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      respond_to do |format|
        format.html { redirect_to request.referrer, notice: 'Comment was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to request.referrer, notice: 'Comment could not be destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def comment_params
    formatted_params = params.require(:comment).permit(:author_id, :comment, :course_id)

    split = split_to_id_and_valid_end(formatted_params[:course_id])

    formatted_params[:course_id] = split[0]
    formatted_params[:course_valid_end] = split[1]
    formatted_params
  end
end
