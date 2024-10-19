class CommentsController < ApplicationController
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
      redirect_to controller: @comment.commentable_type.downcase.pluralize,
                  action: :show,
                  id: @comment.commentable_id,
                  anchor: 'comments',
                  notice: 'Comment was successfully updated.'
    else
      redirect_to controller: @comment.commentable_type.downcase.pluralize,
                  action: :show,
                  id: @comment.commentable_id,
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
    params.require(:comment).permit(:author_id, :comment, :commentable_id, :commentable_type)
  end
end
