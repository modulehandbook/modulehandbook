class CommentsController < ApplicationController
  load_and_authorize_resource

  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      redirect_to request.referrer, notice: 'Comment saved successfully'
    else
      redirect_to request.referrer, error: 'Error saving comment'
    end
  end

  def update; end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to request.referrer, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:author_id, :comment, :commentable_id, :commentable_type)
  end
end
