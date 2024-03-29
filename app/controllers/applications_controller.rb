class ApplicationsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :authenticate_artist!, only: %i[destroy toggle_success]

  before_action :set_opportunity, only: %i[new create destroy]

  def index
    @applications = Application.where(artist: current_artist)
  end

  def new
    @application = Application.new
  end

  def create
    @application = Application.new(application_params)
    @application.opportunity = @opportunity
    @application.artist = current_artist
    if @application.save!
      redirect_to opportunity_path(@opportunity.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @application = Application.find(params[:id])
  end

  def destroy
    @application = Application.find(params[:application])
    @application.destroy
    redirect_to opportunity_path(@opportunity)
  end

  def toggle_success
    @application = Application.find(params[:id])
    @application.update(success: true)
    redirect_to opportunity_path(@application.opportunity)
  end

  private

  def set_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])
  end

  def application_params
    params.require(:application).permit(:content)
  end
end
