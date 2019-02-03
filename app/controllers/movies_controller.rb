class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info, :comment]
  before_action :set_movie, only: [:show, :send_info, :comment, :destroy_comment]

  def index
    @movies = Movie.all.decorate
  end

  def show
    @comments = @movie.comment_threads.order("created_at DESC")
  end

  def send_info
    MovieInfoMailer.send_info(current_user, @movie).deliver_later
    redirect_back(fallback_location: root_path, notice: "Email sent with movie info")
  end

  def export
    file_path = "tmp/movies.csv"
    MovieExportJob.perform_later(current_user, file_path)
    redirect_to root_path, notice: "Movies exported"
  end

  def comment
    comment = Comment.build_from(@movie, current_user.id, comment_params[:body])

    if comment.save
      redirect_to @movie, notice: "Comment successfully created."
    else
      redirect_to @movie, alert: comment.errors.full_messages.join(".") + "."
    end
  end

  def destroy_comment
    comment = Comment.find(params[:comment_id])
    if comment.destroyable_by?(current_user) && comment.destroy
      redirect_to @movie, notice: "Comment successfully deleted"
    else
      redirect_to @movie, alert: "Could not delete comment"
    end
  end

  private

  def set_movie
    @movie = Movie.find(params[:id]).decorate
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
