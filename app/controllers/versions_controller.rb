class VersionsController < ApplicationController
  before_action :set_project
  before_action :set_version, only: [:show, :edit, :update, :destroy]

  # GET /versions
  # GET /versions.json
  def index
    @versions = @project.versions.sort!
  end

  # GET /versions/1
  # GET /versions/1.json
  def show
  end

  # GET /versions/new
  def new
    @version = @project.versions.build
  end

  # GET /versions/1/edit
  def edit
  end

  # POST /versions
  # POST /versions.json
  def create
    @version = @project.versions.build(version_params)

    respond_to do |format|
      if @version.save
        format.html { redirect_to [@project, @version], notice: 'Version was successfully created.' }
        format.json { render :show, status: :created, location: [@version, @project] }
      else
        format.html { render :new }
        format.json { render json: @version.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /versions/1
  # PATCH/PUT /versions/1.json
  def update
    respond_to do |format|
      if @version.update(version_params)
        format.html { redirect_to [@project, @version], notice: 'Version was successfully updated.' }
        format.json { render :show, status: :ok, location: @version }
      else
        format.html { render :edit }
        format.json { render json: @version.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /versions/1
  # DELETE /versions/1.json
  def destroy
    @version.destroy
    respond_to do |format|
      format.html { redirect_to project_versions_url(@project), notice: 'Version was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_version
      @version = @project.versions.find(params[:id])
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    def version_params
      params.require(:version).permit(:major, :mid, :minor, :stable, :rec, :file)
    end
end
