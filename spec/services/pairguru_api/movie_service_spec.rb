require "rails_helper"

RSpec.describe PairguruApi::MovieService do
  describe ".initialize" do
    context "response has data field" do
      subject { described_class.new({ data: "dat" }, 200) }

      it { is_expected.to have_attributes(data: "dat", status: 200) }
    end

    context "response has no data field" do
      subject { described_class.new({ message: "mes" }, 200) }

      it { is_expected.to have_attributes(data: { message: "mes" }, status: 200) }
    end
  end

  describe ".request" do
    subject { described_class.request }

    it "calls EndpointRequestService new with proper arguments at first call" do
      PairguruApi::EndpointRequestService.class_variable_set(:@@request, nil)

      expect(PairguruApi::EndpointRequestService).to receive(:new)
        .with(described_class.resource_name)

      subject
    end

    it "does not call EndpointRequestService new at second call" do
      subject

      expect(PairguruApi::EndpointRequestService).not_to receive(:new)
      subject
    end

    it "returns EndpointRequestService connection" do
      allow(described_class).to receive(:request).and_return(:req)

      expect(subject).to eq(:req)
    end
  end

  describe ".resource_name" do
    subject { described_class.resource_name }
    it { is_expected.to eq("movies") }
  end

  describe ".find" do
    before do
      allow(described_class).to receive_message_chain("request.get") do
        [{ id: "6",
           type: "movie",
           attributes:           { title: "Godfather",
                                   plot: "The aging patriarch.",
                                   rating: 9.2,
                                   poster: "/godfather.jpg" } },
         200]
      end
    end

    subject { described_class.find("Godfather") }

    it "returns object of MovieService class" do
      expect(subject).to be_a(described_class)
    end

    it {
      is_expected.to have_attributes(title: "Godfather", plot: "The aging patriarch.", rating: 9.2)
    }
  end
end
