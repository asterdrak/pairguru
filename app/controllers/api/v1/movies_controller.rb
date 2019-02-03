module Api
  module V1
    class MoviesController < ActionController::API
      def index
        render json: Movie.all.select(:id, :title)
      end

      def show
        render json: Movie.find(params[:id])
      end
    end
  end
end
