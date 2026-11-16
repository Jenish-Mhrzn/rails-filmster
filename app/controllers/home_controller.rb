class HomeController < ApplicationController
  def index
    mb = MovieBuilder.new(Movie.all)
    @detail = mb.detail
  end
end
