require 'sinatra'
require 'pg'
require_relative 'movie'
require 'pry'
require 'tilt/erb'

# binding.pry
#
get '/' do
  redirect '/actors'
end

get '/actors' do
  page = params["page"]
  actors = Actor.list(params)
  erb :'actors/index', locals: { actors: actors, page: page }
end

get '/actors/:id' do
  id = params[:id]
  actor = Actor.find(id)
  erb :'actors/show', locals: { actor: actor }
end


# how to pass search query from post to get
get '/movies' do
  page = params["page"]
  # binding.pry
  movies = Movie.list(params)
  erb :'movies/index', locals: { movies: movies, page: page }
end

# post '/movies' do
#   binding.pry
  # query = param[:query]
#   redirect '/movies/' + params[] # construct the query URL
# end

get '/movies/:id' do
  id = params[:id]
  movie = Movie.find(id)
  erb :'movies/show', locals: { movie: movie }
end
