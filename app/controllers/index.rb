get '/' do
  @movies = Movie.biodome_positive
  erb :index
end

get '/movies/:id' do
  @movie = Movie.find(params[:id])
  erb :show
end

post '/movies' do
  title = params[:title].split(' ').join('+').gsub('&', '%26')
  movie = MovieFetcher.fetch(title)
  if movie
    redirect "/movies/#{movie.id}"
  else
    redirect '/'
  end
end
