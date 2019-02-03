require "rails_helper"

describe Genre do
  let(:genre) { create(:genre) }
  before { create_list(:movie, 2, genre: genre) }

  describe "#movies_count" do
    subject { genre.movies_count }
    it { is_expected.to eq(2) }
  end
end
