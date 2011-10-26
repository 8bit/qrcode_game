class HomeController < ApplicationController
  def index
    if current_user
      if session[:snapback]
        redirect_to session[:snapback]
      else
        redirect_to locations_path
      end
    end
  end
end