class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # binding.pry
    session.clear if params[:clear_session]
    # Ratings
    @all_ratings = Movie.all_ratings
    if params[:ratings]
      @selected_ratings = session[:ratings] = params[:ratings].keys
    else
      if session[:ratings]
        @selected_ratings = session[:ratings]
        redirect = true
      else
        @selected_ratings = session[:ratings] = @all_ratings
      end
    end
    # @selected_ratings = params[:ratings].nil? ? @all_ratings : params[:ratings].keys
    @movies = Movie.where(rating: @selected_ratings)
    # Sorting
    if params[:sort]
      @movies = @movies.order params[:sort]
      @ordered_by = params[:sort]
      session[:sort] = params[:sort]
      sort = true
    elsif session[:sort]
      @movies = @movies.order session[:sort]
      @ordered_by = session[:sort]
      redirect = true
      sort = true
    end
    if redirect
      flash.keep
      sr = {}
      @selected_ratings.each {|r| sr["ratings[#{r}]"] = 1}
      sr[:sort] = @ordered_by if sort = true
      redirect_to movies_path(sr) 
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
