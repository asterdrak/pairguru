require "rails_helper"

describe "Movies requests - api v1", type: :request do
  let!(:movies) { create_list(:movie, 5) }

  describe "#index" do
    it "renders proper json" do
      visit api_v1_movies_path
      expect(JSON.parse(page.body)).to match_array(movies.map { |mvi| mvi.slice("id", "title") })
    end
  end

  describe "#show" do
    it "renders proper json" do
      visit api_v1_movie_path(movies.first.id)
      movie_attributes = ["id", "title", "description", "avatar", "genre_id"]
      expect(JSON.parse(page.body)).to include(movies.first.slice(movie_attributes))
    end
  end
end
