get '/' do
  @movies = Movie.biodome_positive
  erb :index
end

get '/movies/:id' do
  @movie = Movie.find(params[:id])
  @biodome_effects = @movie.get_biodome_effects
  erb :show
end

post '/movies' do
  title = params[:title]
  movie = MovieFetcher.fetch(title)
  if movie
    redirect "/movies/#{movie.id}"
  else
    redirect '/'
  end
end
