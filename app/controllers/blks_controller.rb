class BlksController < ApplicationController
  before_action :set_blk, only: [:show, :edit, :update, :destroy]

  # GET /blks
  # GET /blks.json
  def index
    @blks = Blk.all
  end

  # GET /blks/1
  # GET /blks/1.json
  def show
  end

  # GET /blks/new
  def new
    @blk = Blk.new
  end

  # GET /blks/1/edit
  def edit
  end

  # POST /blks
  # POST /blks.json
  def create
    @blk = Blk.new(blk_params)

    respond_to do |format|
      if @blk.save
        format.html { redirect_to @blk, notice: 'Blk was successfully created.' }
        format.json { render action: 'show', status: :created, location: @blk }
      else
        format.html { render action: 'new' }
        format.json { render json: @blk.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blks/1
  # PATCH/PUT /blks/1.json
  def update
    respond_to do |format|
      if @blk.update(blk_params)
        format.html { redirect_to @blk, notice: 'Blk was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @blk.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blks/1
  # DELETE /blks/1.json
  def destroy
    @blk.destroy
    respond_to do |format|
      format.html { redirect_to blks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blk
      @blk = Blk.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blk_params
      params.require(:blk).permit(:title, :url, :project_id, :contract, :neighbourhood)
    end
end
