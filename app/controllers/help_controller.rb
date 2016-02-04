class HelpController < ApplicationController
  def index
    @inputfiles = Inputfile.where('name ~* :pat', :pat => 'Sample Menu [123]')
  end
end