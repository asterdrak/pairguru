class MovieDecorator < Draper::Decorator
  delegate_all

  def cover
    "https://pairguru-api.herokuapp.com/" +
      object.title.parameterize(separator: "_") + ".jpg"
  end

  def movie_resource
    @movie_resource ||= PairguruApi::MovieService.find(object.title)
  end

  delegate :plot, :rating, :poster, to: :movie_resource
end
