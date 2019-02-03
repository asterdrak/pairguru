# == Schema Information
#
# Table name: genres
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

class Genre < ApplicationRecord
  has_many :movies, dependent: :restrict_with_exception

  def movies_count
    movies.size
  end
end
