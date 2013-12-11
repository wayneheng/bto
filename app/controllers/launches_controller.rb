class LaunchesController < ApplicationController
  before_action :set_launch, only: [:show, :edit, :update, :destroy]

  # GET /launches
  # GET /launches.json
  def index
    @launches = Launch.all
    
    respond_to do |format|
      
      format.html
      format.json {
        
        @launch_list = @launches.map do |launch|
          {:id => launch.id, :title => launch.title, :imagePath => launch.imagePath, :version => launch.version,
           
           :projects => launch.projects.map do |project|
               {:id => project.id, :title => project.title, :flat_type => project.flat_type, :version => project.version}
           end
          }
        end
        
        render :json => @launch_list.to_json   
      }
    end
    
    
  end

  # GET /launches/1
  # GET /launches/1.json
  def show
    
  end

  # GET /launches/new
  def new
    @launch = Launch.new
  end

  # GET /launches/1/edit
  def edit
  end

  # POST /launches
  # POST /launches.json
  def create
    @launch = Launch.new(launch_params)

    respond_to do |format|
      if @launch.save
        format.html { redirect_to @launch, notice: 'Launch was successfully created.' }
        format.json { render action: 'show', status: :created, location: @launch }
      else
        format.html { render action: 'new' }
        format.json { render json: @launch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /launches/1
  # PATCH/PUT /launches/1.json
  def update
    respond_to do |format|
      if @launch.update(launch_params)
        format.html { redirect_to @launch, notice: 'Launch was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @launch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /launches/1
  # DELETE /launches/1.json
  def destroy
    @launch.destroy
    respond_to do |format|
      format.html { redirect_to launches_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_launch
      @launch = Launch.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def launch_params
      params.require(:launch).permit(:title, :version, :imagePath)
    end
end
