class CommentsController < ApplicationController
  load_and_authorize_resource

  def create; end

  def update; end

  def delete; end

  private

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:author, :comment)
  end
end
