class CommentsController < ApplicationController
  before_filter :authenticate_admin_user!
  respond_to :json

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_with(@comment)
  end

end