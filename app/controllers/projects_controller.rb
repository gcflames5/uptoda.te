class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :check, :download]

  # GET /projects
  # GET /projects.json
  def index
    @projects = current_user.projects
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = current_user.projects.build
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = current_user.projects.build(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /projects/1/check.json
  def check
    major = params[:major].to_i
    mid = params[:mid].to_i
    minor = params[:minor].to_i

    version = @project.grab_version(major, mid, minor, params[:type].to_sym)
    if version.nil?
      render json: {
        error: "Requested version not found.",
        project_name: @project.name,
        requested_version: [major, mid, minor],
        request_type: params[:type].to_sym
        }, status: :ok
    else
      render json: {
        update_available: !version.matches?(major, mid, minor),
        project_name: @project.name,
        requested_version: [major, mid, minor],
        new_version: [version.major, version.mid, version.minor],
        request_type: params[:type].to_sym
        }, status: :ok
    end
  end

  # GET /projects/1/download
  def download
    major = params[:major].to_i
    mid = params[:mid].to_i
    minor = params[:minor].to_i

    version = @project.grab_version(major, mid, minor, params[:type].to_sym)
    if version.nil?
      render json: {
        error: "Requested version not found.",
        project_name: @project.name,
        requested_version: [major, mid, minor],
        request_type: params[:type].to_sym
        }, status: :ok
    else
      send_file(version.file.path,
        :filename      =>  @project.name.gsub(" ", "") + "-" + version.major.to_s + "." + version.mid.to_s + "." + version.minor.to_s,
        :disposition  =>  'attachment'
        )
      version.downloads << Download.create(ip: request.remote_ip)
    end
  end

  private
    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:name, :desc)
    end
end
