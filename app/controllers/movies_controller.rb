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
    
    sort_key = params[:sort]
    sort_key_from_session = false
    if params[:sort].nil?
      sort_key = session[:sort]
      sort_key_from_session = true
    end
      
    ratings_keys = params[:ratings]
    ratings_keys_from_session = false
    if params[:ratings].nil?
      if session[:ratings].nil?
        ratings_keys = {}
      else
        ratings_keys = session[:ratings].keys
        ratings_keys_from_session = true
      end
    else
      ratings_keys = ratings_keys.keys
    end
    
    if params[:sort] != session[:sort]
      session[:sort] = sort
      flash.keep
      #redirect_to sort: sort_key, ratings: ratings_keys 
    end
    
#     if params[:ratings]
#       @ratings_checked = params[:ratings].keys
#       session[:ratings] = params[:ratings]
#     else
#       if session[:ratings]
#         @ratings_checked = session[:ratings].keys
#       else
#         @ratings_checked = @all_ratings
#       end
#     end
    
#     if params[:sort]
#       @movies = Movie.order(params[:sort])
#       session[:sort] = params[:sort]
#     else
#       if session[:sort]
#         @movies = Movie.order(session[:sort]).where(:rating => @ratings_checked)
#       else
#         @movies = Movie.where(:rating => @ratings_checked)
#       end
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
