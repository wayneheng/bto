class TownProjectsController < ApplicationController
  before_action :set_town_project, only: [:show, :edit, :update, :destroy]

  # GET /town_projects
  # GET /town_projects.json
  def index
    @town_projects = TownProject.all
  end

  # GET /town_projects/1
  # GET /town_projects/1.json
  def show
  end

  # GET /town_projects/new
  def new
    @town_project = TownProject.new
  end

  # GET /town_projects/1/edit
  def edit
  end

  # POST /town_projects
  # POST /town_projects.json
  def create
    @town_project = TownProject.new(town_project_params)

    respond_to do |format|
      if @town_project.save
        format.html { redirect_to @town_project, notice: 'Town project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @town_project }
      else
        format.html { render action: 'new' }
        format.json { render json: @town_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /town_projects/1
  # PATCH/PUT /town_projects/1.json
  def update
    respond_to do |format|
      if @town_project.update(town_project_params)
        format.html { redirect_to @town_project, notice: 'Town project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @town_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /town_projects/1
  # DELETE /town_projects/1.json
  def destroy
    @town_project.destroy
    respond_to do |format|
      format.html { redirect_to town_projects_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_town_project
      @town_project = TownProject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def town_project_params
      params.require(:town_project).permit(:town_name)
    end
end
