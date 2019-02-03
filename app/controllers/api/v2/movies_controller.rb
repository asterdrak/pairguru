module Api
  module V2
    class MoviesController < ActionController::API
      def index
        render json: Movie.includes(genre: :movies).all.select(:id, :title, :genre_id),
               except: :genre_id, include: { genre: { only: [:id, :name], methods: :movies_count } }
      end
    end
  end
end
