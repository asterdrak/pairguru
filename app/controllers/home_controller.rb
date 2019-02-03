class HomeController < ApplicationController
  def welcome; end

  def top_users
    @users_counted = Comment.where(created_at: 7.days.ago..Time.zone.now)
      .group(:user).limit(10).count
  end
end
