require 'open-uri'

class MovieFetcher
  class << self
    def fetch(title)
      title = title.split(' ').map{ |word| word.capitalize }.join(' ')
      movie = Movie.find_by_title(title)
      return movie if movie
      title = title.split(' ').join('+').gsub('&', '%26')
      find_and_create_movie(title)
    end

    def find_and_create_movie(title)
      data = open("http://www.omdbapi.com/?t=#{title}&r=json")
      parsed_data = eval(data.read)
      create_movie(parsed_data)
    end

    def create_movie(data)
      ratings                 = fetch_ratings(data[:imdbID])
      ratings_male            = fetch_ratings(data[:imdbID], 'ratings-male')
      ratings_female          = fetch_ratings(data[:imdbID], 'ratings-female')
      ratings_under_18        = fetch_ratings(data[:imdbID], 'ratings-age_1')
      ratings_male_under_18   = fetch_ratings(data[:imdbID], 'ratings-male_age_1')
      ratings_female_under_18 = fetch_ratings(data[:imdbID], 'ratings-female_age_1')
      ratings_18_29           = fetch_ratings(data[:imdbID], 'ratings-age_2')
      ratings_male_18_29      = fetch_ratings(data[:imdbID], 'ratings-male_age_2')
      ratings_female_18_29    = fetch_ratings(data[:imdbID], 'ratings-female_age_2')
      ratings_30_44           = fetch_ratings(data[:imdbID], 'ratings-age_3')
      ratings_male_30_44      = fetch_ratings(data[:imdbID], 'ratings-male_age_3')
      ratings_female_30_44    = fetch_ratings(data[:imdbID], 'ratings-female_age_3')
      ratings_45              = fetch_ratings(data[:imdbID], 'ratings-age_4')
      ratings_male_45         = fetch_ratings(data[:imdbID], 'ratings-male_age_4')
      ratings_female_45       = fetch_ratings(data[:imdbID], 'ratings-female_age_4')
      is_biodome = is_biodome?(ratings)

      Movie.create({
        title: data[:Title],
        imdb_id: data[:imdbID],
        ratings: ratings,
        biodome:is_biodome,
        ratings_male:            ratings_male,
        ratings_female:          ratings_female,
        ratings_under_18:        ratings_under_18,
        ratings_male_under_18:   ratings_male_under_18,
        ratings_female_under_18: ratings_female_under_18,
        ratings_18_29:           ratings_18_29,
        ratings_male_18_29:      ratings_male_18_29,
        ratings_female_18_29:    ratings_female_18_29,
        ratings_30_44:           ratings_30_44,
        ratings_male_30_44:      ratings_male_30_44,
        ratings_female_30_44:    ratings_female_30_44,
        ratings_45:              ratings_45,
        ratings_male_45:         ratings_male_45,
        ratings_female_45:       ratings_female_45
      })
    end

    def fetch_ratings(imdb_id, category = 'ratings')
      page = Nokogiri::HTML(open("http://www.imdb.com/title/#{imdb_id}/#{category}"))
      ratings = []
      page.css('table').first.css('tr').each_with_index do |rating, index|
        ratings << rating.css('td').first.content unless index == 0
      end
      ratings
    end

    def is_biodome?(ratings)
      ten = ratings.first
      one = ratings.last
      ratings.each_with_index do |rating, idx|
        next if idx == 0 || idx == 9
        return false if rating.to_i > ten.to_i || rating.to_i > one.to_i
      end
      true
    end
  end
end