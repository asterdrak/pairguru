require "rails_helper"

RSpec.describe MovieExportJob, type: :job do
  describe "#perform" do
    subject { MovieExportJob.perform_now(:user, :file_path) }

    it "calls MovieExporter call" do
      expect(MovieExporter).to receive_message_chain("new.call").with(:user, :file_path)

      subject
    end
  end
end
