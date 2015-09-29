require 'pg'
require 'pry'

DB_NAME = 'movies'

def db_connection
  begin
    connection = PG.connect(dbname: DB_NAME)
    yield(connection)
  ensure
    connection.close
  end
end

class Actor

  attr_reader :id, :name, :character, :num_movies

  def initialize(actor_info)
    @id = actor_info["id"]
    @name = actor_info["name"]
    @character = actor_info["character"]
    @num_movies = num_movies
  end

  def self.list(params)
    options = params_convert(params)
    list = nil
    db_connection do |conn|
      sql_query = "SELECT id, name FROM actors
      #{options}"
      list = conn.exec(sql_query)
      list = list.map { |actor| self.new(actor) }
    end
  end

  def self.search_result(params)
    options = params_convert(params)
    list = nil
    db_connection do |conn|
      sql_query = "SELECT actors.id, actors.name, cast_members.character
      FROM actors
      LEFT JOIN cast_members ON actors.id = cast_members.actor_id
      #{options}"
      list = conn.exec(sql_query)
      list = list.map { |actor| self.new(actor) }
    end
  end

  def self.params_convert(params)
    order = "ORDER BY LOWER(name)"
    "#{search(params)} #{order} #{page(params)}"
  end

  def self.page(params)
    page = params["page"] || 1
    offset = (page.to_i - 1) * 20
    "LIMIT 20 OFFSET #{offset}"
  end

  def self.search(params)
    query = params["query"]
    unless query.nil?
      "WHERE to_tsvector('simple', actors.name||' '||coalesce(cast_members.character,'')) @@ plainto_tsquery('simple', '#{query}')"
    else
      ""
    end
  end

  def self.find(id, options='')
    result = nil
    db_connection do |conn|
      sql = "SELECT actors.id, actors.name
      FROM actors
      WHERE actors.id = $1
      #{options}"
      result = conn.exec_params(sql, [id]).first
    end
    Actor.new(result)
  end

  def num_movies
    db_connection do |conn|
      sql = "SELECT COUNT(*)
      FROM movies
      LEFT JOIN cast_members ON movies.id = cast_members.movie_id
      LEFT JOIN actors ON cast_members.actor_id = actors.id
      WHERE actors.id = $1"
      movies = conn.exec_params(sql, [id]).first["count"]
    end
  end

  def movies(options='')
    movies = nil
    db_connection do |conn|
      sql = "SELECT movies.id, movies.title, movies.year, cast_members.character
      FROM movies
      LEFT JOIN cast_members ON movies.id = cast_members.movie_id
      LEFT JOIN actors ON cast_members.actor_id = actors.id
      WHERE actors.id = $1
      #{options}"
      movies = conn.exec_params(sql, [id])
    end
    movies.map { |movie| Movie.new(movie) }
  end

end

class Movie

  attr_reader :id, :title, :year, :rating, :genre, :studio, :synopsis, :character

  def initialize(movie_info)
    @id = movie_info["id"]
    @title = movie_info["title"]
    @year = movie_info["year"]
    @rating = movie_info["rating"]
    @genre = movie_info["genre"]
    @studio = movie_info["studio"]
    @synopsis = movie_info["synopsis"]
    @character = movie_info["character"]
  end

  def self.params_convert(params)
    "#{search(params)} #{order(params)} #{page(params)}"
  end

  def self.order(params)
    order = params["order"]
    options_array = {
      "year" => "ORDER BY movies.year DESC",
      "rating" => "WHERE movies.rating IS NOT NULL
      ORDER BY movies.rating DESC"
    }
    options_array[order] || 'ORDER BY LOWER(movies.title)'
  end

  def self.page(params)
    page = params["page"] || 1
    offset = (page.to_i - 1) * 20
    "LIMIT 20 OFFSET #{offset}"
  end

  def self.search(params)
    query = params["query"]
    "WHERE to_tsvector('simple', movies.title) @@ plainto_tsquery('simple', '#{query}')"
  end

  def self.list(params)
    options = params_convert(params)
    list = nil
    db_connection do |conn|
      sql_query = "SELECT movies.id, movies.title, movies.year, movies.rating, movies.synopsis, genres.name AS genre, studios.name AS studio
      FROM movies
      LEFT JOIN genres ON movies.genre_id = genres.id
      LEFT JOIN studios ON movies.studio_id = studios.id
      #{options}"
      binding.pry
      list = conn.exec(sql_query)
      list = list.map { |movie| self.new(movie) }
    end
  end

  def self.find(id, options='')
    result = nil
    db_connection do |conn|
      sql = "SELECT DISTINCT movies.id, movies.title, movies.year, movies.rating, movies.synopsis, genres.name AS genre, studios.name AS studio
      FROM movies
      LEFT JOIN cast_members ON movies.id = cast_members.movie_id
      LEFT JOIN actors ON cast_members.actor_id = actors.id
      LEFT JOIN genres ON movies.genre_id = genres.id
      LEFT JOIN studios ON movies.studio_id = studios.id
      WHERE movies.id = $1
      #{options}"
      result = conn.exec_params(sql, [id]).first
    end
    Movie.new(result)
  end

  def actors(options='')
    actors = nil
    db_connection do |conn|
      sql = "SELECT actors.id, actors.name, cast_members.character
      FROM movies
      LEFT JOIN cast_members ON movies.id = cast_members.movie_id
      LEFT JOIN actors ON cast_members.actor_id = actors.id
      WHERE movies.id = $1
      #{options}"
      actors = conn.exec_params(sql, [id])
    end
    actors.map { |actor| Actor.new(actor) }
  end

end
