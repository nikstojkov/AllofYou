class ArtistsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_artist, only: %i[show update edit destroy]

  # @artists = Artist.where(title: params[:query])

  def index
    @artist_tags = ArtistTag.all
    if params[:query].present?
      @artists = Artist.joins(:tags).where(tags: { name: params[:query] })
    else
      @artists = Artist.all
    end
  end

  # def index
  #   if params[:query].present?
  #     sql_query = <<~SQL
  #       movies.title @@ :query
  #       OR movies.synopsis @@ :query
  #       OR directors.first_name @@ :query
  #       OR directors.last_name @@ :query
  #     SQL
  #     @movies = Movie.joins(:director).where(sql_query, query: "%#{params[:query]}%")
  #   else
  #     @movies = Movie.all
  #   end
  # end

  def show
    @artworks = @artist.artworks
    @tags = @artist.tags
    @applications = @artist.applications
    @artist_opportunities = @artist.opportunities
  end

  def edit
  end

  def update
    @artist.update(artist_params)
    redirect_to current_user
  end

  def destroy
    @artist.destroy
    redirect_to new_artist_registration
  end

  private

  def artist_params
    params.require(:artist).permit(:location, :first_name, :last_name, :tags, :bio)
  end

  def set_artist
    @artist = Artist.find(params[:id])
  end

end
