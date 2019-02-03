# == Schema Information
#
# Table name: movies
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  released_at :datetime
#  avatar      :string
#  genre_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Movie < ApplicationRecord
  belongs_to :genre

  acts_as_commentable

  def commentable_by?(user)
    Comment.find_by(commentable_type: "Movie", commentable_id: id, user: user).blank?
  end
end
