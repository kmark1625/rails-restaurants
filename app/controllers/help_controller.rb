class HelpController < ApplicationController
  def index
    @inputfiles = Inputfile.all
  end
end