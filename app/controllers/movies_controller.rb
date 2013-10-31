class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    session.clear if params[:clear_session]
    @sort = 
      if params[:sort] 
        session[:sort] = params[:sort]
      elsif session[:sort]
        redirect = true
        session[:sort]
      end
    @all_ratings = Movie.all_ratings
    @selected_ratings = 
      if params[:ratings]
        session[:ratings] = params[:ratings]
      elsif session[:ratings]
        redirect = true
        session[:ratings]
      else
        Hash[@all_ratings.map {|r| [r,1]}]
      end
    redirect_to sort: @sort, ratings: @selected_ratings if redirect
    @movies = Movie.where(rating: @selected_ratings.keys).order(@sort)
  end

  # little less efficient : redirect also on params change
  def index2
    session.clear if params[:clear_session]
    @sort = params[:sort] || session[:sort]
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || Hash[@all_ratings.map {|r| [r,1]}]
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = @sort
      session[:ratings] = @selected_ratings
      redirect_to sort: @sort, ratings: @selected_ratings
    end
    @movies = Movie.where(rating: @selected_ratings.keys).order(@sort)
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
