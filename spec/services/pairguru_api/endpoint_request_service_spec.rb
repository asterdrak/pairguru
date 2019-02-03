require "rails_helper"

RSpec.describe PairguruApi::EndpointRequestService do
  describe ".initialize" do
    it "properly sets up resource_name" do
      expect(described_class.new("movies")).to have_attributes(resource_name: "movies")
    end
  end

  describe "#connection" do
    subject { described_class.new("movies") }

    it "calls faraday new with proper arguments at first call" do
      expect(Faraday).to receive(:new).with(url: "https://pairguru-api.herokuapp.com/api/v1/movies")

      subject.connection
    end

    it "does not call faraday new at second call" do
      subject.connection

      expect(Faraday).not_to receive(:new)
      subject.connection
    end

    it "returns faraday connection" do
      allow(Faraday).to receive(:new).with(url: "https://pairguru-api.herokuapp.com/api/v1/movies")
        .and_return(:fconn)

      expect(subject.connection).to eq(:fconn)
    end
  end

  describe "#get" do
    subject { described_class.new("movies") }

    let(:response) do
      OpenStruct.new(status: 200, body: '{"data":{"id":"7","type":"movie","attributes":' +
        '{"title":"The Dark Knight", "plot":"When the menace known as the Joker wreaks havoc and' +
        "chaos on the people of Gotham, the Dark Knight must come to terms with one of the" +
        'greatest psychological tests of his ability tofight injustice.","rating":9.0,' +
        '"poster":"/the_dark_knight.jpg"}}}')
    end

    before do
      allow(subject).to receive_message_chain("connection.get") { response }
      Rails.cache.clear
    end

    it "returns [parsed_body, status]" do
      expect(subject.get("dark knight", {})).to eq([JSON.parse(response.body).deep_symbolize_keys,
                                                    200])
    end

    it "calls connection get if cache is clear" do
      expect(subject).to receive_message_chain("connection.get").with("dark knight")

      subject.get("dark knight", {})
    end

    it "does not return cached response if cache is clear" do
      subject.get("dark knight", {})

      response.status = 404
      Rails.cache.clear
      expect(subject.get("dark knight", {}).last).to eq(404)
    end

    it "returns cached response" do
      subject.get("dark knight", {})

      response.status = 404
      expect(subject.get("dark knight", {}).last).to eq(200)
    end
  end
end
