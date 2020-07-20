class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
      
    if params[:ratings] and params[:sort]
      @ratings_checked = params[:ratings].keys
      session[:ratings] = params[:ratings]
      session[:sort] = params[:sort]
      @movies = Movie.where(:rating => @ratings_checked).order(params[:sort])
    elsif params[:ratings]
      @ratings_checked = params[:ratings].keys
      session[:ratings] = params[:ratings]
      @movies = Movie.where(:rating => @ratings_checked).order(session[:sort])
    elsif params[:sort]
      @ratings_checked = session[:ratings]
      if session[:ratings]
        @ratings_checked = session[:ratings].keys
      else
        @ratings_checked = @all_ratings
      end
      session[:sort] = params[:sort]
      @movies = Movie.where(:rating => @ratings_checked).order(params[:sort])
    else
      @ratings_checked = session[:ratings]
      if session[:ratings]
        @ratings_checked = session[:ratings].keys
      else
        @ratings_checked = @all_ratings
      end
      @movies = Movie.where(:rating => @ratings_checked).order(session[:sort])
    end
      
#     if params[:ratings]
#       @ratings_checked = params[:ratings].keys
#       session[:ratings] = params[:ratings]
#     else
#       @ratings_checked = session[:ratings].keys
#     end
    
#     if params[:sort]
#       @movies = Movie.where(:rating => @ratings_checked).order(params[:sort])
#       session[:sort] = params[:sort]
#     else
#       @movies = Movie.where(:rating => @ratings_checked)
#     end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
