class InputfilesController < ApplicationController
  def index
    @inputfiles = Inputfile.all
  end

  def new
    @inputfile = Inputfile.new
  end

  def create
    @inputfile = Inputfile.new(inputfile_params)

    if @inputfile.save
      redirect_to inputfiles_path, notice: "The input file #{@inputfile.name} has been uploaded"
    else
      render "new"
    end
  end

  def destroy
    @inputfile = Inputfile.find(params[:id])
    @inputfile.destroy
    redirect_to inputfiles_path,
    notice: "The input file #{@inputfile.name} has been deleted"
  end

  private
  def inputfile_params
    params.require(:inputfile).permit(:name, :attachment)
  end
end
