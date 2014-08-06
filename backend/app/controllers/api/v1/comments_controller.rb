module API::V1
  class CommentsController < ApplicationController
    before_action :ensure_valid_api_key!, only: [:create, :update]

    def index
      @comments = Comment.order(created_at: :desc).limit(25)
      @comments = @comments.where(id: params[:ids]) if params[:ids]

      render json: @comments, include: [:user]
    end

    def show
      @comment = Comment.find(params[:id])

      render json: @comment
    end

    def create
      @comment = current_user.comments.build(comment_params)
      @comment.commentable

      if @comment.save
        render json: @comment,
          status: :created,
          location: [:api, :v1, @comment]
      else
        render json: { errors: @comment.errors }, status: :unprocessable_entity
      end
    end

    private
    def comment_params
      params.require(:comment).permit(:body, :commentable_id, :commentable_type)
    end
  end
end