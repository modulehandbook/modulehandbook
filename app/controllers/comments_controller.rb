# frozen_string_literal: true

class CommentsController < ApplicationController
  load_and_authorize_resource

  def index
    @comments = @comments.reverse_order
  end
  def show; end

  def edit; end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to request.referrer, notice: I18n.t('controllers.comments.saved')
    else
      redirect_to request.referrer, error: I18n.t('controllers.comments.error_save')
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to controller: @comment.commentable_type.downcase.pluralize,
                  action: :show,
                  id: @comment.commentable_id,
                  anchor: 'comments',
                  notice: I18n.t('controllers.comments.updated')
    else
      redirect_to controller: @comment.commentable_type.downcase.pluralize,
                  action: :show,
                  id: @comment.commentable_id,
                  anchor: 'comments',
                  notice: I18n.t('controllers.comments.error_update')
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      respond_to do |format|
        format.html { redirect_to request.referrer, notice: I18n.t('controllers.comments.destroyed') }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to request.referrer, notice: I18n.t('controllers.comments.error_destroy') }
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
