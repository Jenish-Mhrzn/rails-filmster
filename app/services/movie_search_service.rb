require "uri"
require 'net/http'
require 'json'
class MovieSearchService
    def initialize(query)
        @query=query
    end

    def call
        #search in db first
         movies = Movie.where(
            "title LIKE ?",
            "%#{Movie.sanitize_sql_like(@query)}%"
        )
         
        #return from db if exist, otherwise call the api 
        if movies.exists?
            movies
        else
            fetch_from_tmdb
        end
    end

    private     

    def fetch_from_tmdb
        url=URI("https://api.themoviedb.org/3/search/movie?query=#{URI.encode_www_form_component(@query)}")
        http=Net::HTTP.new(url.host, url.port)
        http.use_ssl=true

        request=Net::HTTP::Get.new(url)
        request['Accept']='application/json'
        request['Authorization'] = "Bearer #{ENV.fetch('TMDB_API_KEY')}"

        response=http.request(request)
        movie_data=JSON.parse(response.body)
        # puts "TMDB status: #{response.code}"
        # puts "TMDB body: #{response.body}"
        results=movie_data['results'] || []
        results.each do |movie| 
            Movie.find_or_create_by!(tmdb_id: movie['id']) do |new_movie|
                new_movie.title = movie['title']
                new_movie.overview = movie['overview']
                new_movie.poster_path = movie['poster_path']
                new_movie.backdrop_path = movie['backdrop_path']
                new_movie.release_date = movie['release_date'].presence
                new_movie.popularity = movie['popularity']
                new_movie.vote_average = movie['vote_average']
                new_movie.vote_count = movie['vote_count']
            end
        end
        # fetch movie from local db
        @movies=Movie.where(tmdb_id: results.map {|movie| movie['id']})
    end            
end