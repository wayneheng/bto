class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :setup]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
   
    respond_to do |format|
      
      format.html
      format.json {
        
        blk_list = @project.blks.map do |blk|
           {:id => blk.id, :blk_title => blk.title, :mapPath => blk.mapPath}
        end
        
        @project_details = {
         
          :version => @project.version,
          :blks => blk_list,
          :units => @project.units.map do |u|
            {:id => u.id, :title => u.title, :price => u.price, :is_taken => u.is_taken, :blk => u.blk, :taken_date => u.taken_date.to_i}  
          end
          
        }
        render :json => @project_details.to_json   
      }
    end
    
  end

  def setup
    10.times { @project.blks.build }    
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    
    puts "Project Params:" + project_params.inspect
    
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:index, :title, :flat_type, :version, :launch_id, :town_project_id,
                                      :blks_attributes => [:id, :title, :url, :mapPath, :contract, :neighbourhood, :_destroy])
    end
end
