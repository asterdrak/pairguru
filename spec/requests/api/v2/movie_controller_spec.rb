require "rails_helper"

describe "Movies requests - api v2", type: :request do
  let!(:movies) { create_list(:movie, 5) }

  describe "#index" do
    it "renders proper movie json" do
      visit api_v2_movies_path
      movies_from_body = JSON.parse(page.body).map { |movie| movie.slice("id", "title") }

      expect(movies_from_body).to match_array(movies.map { |mvi| mvi.slice("id", "title") })
    end

    it "includes genre info" do
      visit api_v2_movies_path
      genres_from_body = JSON.parse(page.body).map { |movie| movie.slice("genre")["genre"] }
      genres_hashes = Genre.all.map { |genre| genre.slice(:id, :name, :movies_count) }

      expect(genres_from_body).to match_array(genres_hashes)
    end
  end
end
