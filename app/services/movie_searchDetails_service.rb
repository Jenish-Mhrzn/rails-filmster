require 'uri'
require 'net/http'
require 'json'
class MovieDetailsService
    def initialize(movie)
        @movie=movie
    end

    def call
        fetch_details_from_tmdb
    end

    private
    def fetch_details_from_tmdb
        url=URI("https://api.themoviedb.org/3/movie/#{@movie.tmdb_id}")
        http=Net::HTTP.new(url.host, url.port)
        http.use_ssl=true

        request=Net::HTTP::Get.new(url)
        request['Accept']='application/json'
        request['Authorization']="Bearer #{ENV.fetch('TMDB_API_KEY')}"

        response=http.request(request)
        details=JSON.parse(response.body)
        # puts "TMDB ko status: #{response.code}"
        # puts "TMDB body: #{response.body}"
        @movie.update(
            runtime: details['runtime'],
            budget: details['budget'],
            homepage: details['homepage'],
            overview: details['overview'],
            backdrop_path: details['backdrop_path'],
            vote_average: details['vote_average'],
            vote_count: details['vote_count'],
            release_date: details['release_date'].presence,
            popularity: details['popularity']
        )
    end
end