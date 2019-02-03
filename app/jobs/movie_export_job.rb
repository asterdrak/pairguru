class MovieExportJob < ApplicationJob
  queue_as :default

  def perform(user, file_path)
    MovieExporter.new.call(user, file_path)
  end
end
