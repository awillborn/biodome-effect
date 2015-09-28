require 'open-uri'

class MovieFetcher
  class << self
    def fetch(title)
      movie = Movie.find_by_title(title)
      return movie if movie
      find_and_create_movie(title)
    end

    def find_and_create_movie(title)
      data = open("http://www.omdbapi.com/?t=#{title}&r=json")
      parsed_data = eval(data.read)
      create_movie(parsed_data)
    end

    def create_movie(data)
      ratings = fetch_ratings(data[:imdbID])
      is_biodome = is_biodome?(ratings)

      Movie.create({ title: data[:Title], imdb_id: data[:imdbID], ratings: ratings, biodome: is_biodome })
    end

    def fetch_ratings(imdb_id)
      page = Nokogiri::HTML(open("http://www.imdb.com/title/#{imdb_id}/ratings"))
      ratings = []
      page.css('table').first.css('tr').each_with_index do |rating, index|
        ratings << rating.css('td').first.content.to_i unless index == 0
      end
      ratings
    end

    def is_biodome?(ratings)
      ten = ratings.first
      one = ratings.last
      ratings.each_with_index do |rating, idx|
        next if idx == 0 || idx == 9
        return false if rating > ten || rating > one
      end
      true
    end
  end
end