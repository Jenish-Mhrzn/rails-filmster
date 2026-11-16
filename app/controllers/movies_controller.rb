require "uri"
require 'net/http'
require 'json'
class MoviesController < ApplicationController
    def index
        # @movies=Movie.all
        @reviews = Review.includes(:user, :movie).order(created_at: :desc).limit(15)
        if params[:query].present?
        begin
            @movies = MovieSearchService.new(params[:query]).call
        rescue => e
            flash.now[:alert] = "Unable to fetch movies"
            @movies = Movie.none
        end
        else
            @movies = Movie.limit(15)
        end
    end
  
    def show
        @movie=Movie.find(params[:id])
        #check if all details data is fetched
        if @movie.runtime.nil?
            begin
               MovieDetailsService.new(@movie).call
               @movie.reload
            rescue => e
                flash.now[:alert] = "Unable to fetch movie details"
            end
        end
    end

    def destroy
        @movie=Movie.find(params[:id])
        @movie.destroy
        redirect_to root_path
    end
end