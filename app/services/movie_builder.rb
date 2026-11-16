class MovieBuilder
    # def initialize(movie = Object.new)
    #     @movie = movie.is_a?(Movie) ? movie : Movie.new
    # end
    # to get all
    def initialize(movie= Movie.new)
        @movie=movie 
    end

    def update_title(title)
        @movie.update(title: title )
        @movie.save
    end

    def detail
        @movie.inspect
    end
end
