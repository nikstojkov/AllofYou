class ArtworksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :authenticate_artist!, only: %i[show index]

  before_action :set_artwork, only: %i[show edit update destroy]

  def index
    if params[:query].present?
      tagsquery = params[:query].split
      @artworks = Artwork.joins(:tags).where(tags: {name: tagsquery} ).uniq
    else
      @artworks = Artwork.all
    end
  end

  def new
    @artwork = Artwork.new
  end

  def create
    @artwork = Artwork.new(artwork_params)
    @artwork.artist = current_artist
    @new_tags = params[:tags].split(", ")
    @new_tags.each do |tag|
      tag_create = Tag.find_or_create_by(name: tag)
      ArtworkTag.create(tag: tag_create, artwork: @artwork)
    end
    if @artwork.save
      redirect_to artist_path(@artwork.artist)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    artwork.update(artwork_params)
    redirect_to artwork_path(artwork)
  end

  def destroy
    @artwork.destroy
    redirect_to artist_path(current_artist)
  end

  private

  def artwork_params
    params.require(:artwork).permit(:name, :genre, :photo, :tags_container)
  end

  def set_artwork
    @artwork = Artwork.find(params[:id])
  end
end
