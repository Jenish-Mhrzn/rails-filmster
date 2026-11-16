class ReviewsController < ApplicationController
    before_action :set_movie, only[:create, :destroy, :edit, :update]
    before_action :set_review, only[:destroy, :edit, :update]
    def index
        @reviews = Review.includes(:user, :movie).order(created_at: :desc)
    end

    def create
        # @movie=Movie.find(params[:movie_id])
         if current_user
            @review = @movie.reviews.create(
                review_params.merge(user_id: current_user.id)
            )
            redirect_to movie_path(@movie)
        else
            flash[:error] = "Please login to comment."
            redirect_to movie_path(@movie)
        end 
    end

    def destroy
        # @movie=Movie.find(params[:movie_id])
        # @review=@movie.reviews.find(params[:id])
        if @review.user_id==current_user.id
            @review.destroy
        end 
        redirect_to movie_path(@movie)
    end

    def edit
        # @movie=Movie.find(params[:movie_id])
        # @review=@movie.reviews.find(params[:id])
    end

    def update
        # @movie=Movie.find(params[:movie_id])
        # @review=@movie.reviews.find(params[:id])
        if @review.user_id==current_user.id
            @review.update(review_params)
            redirect_to movie_path(@movie)
        else
            redirect_to movie_path(@movie), alert: "You cannot edit this review."
        end
    end
    
    private
    def set_movie
        @movie=Movie.find(params[:movie_id])
    end

    def set_review
        @review=@movie.reviews.find(params[:id])
    end

    def review_params
        params.require(:review).permit(:content)
    end
end
