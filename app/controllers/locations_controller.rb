class LocationsController < ApplicationController
  
  def index 
    if current_user
      @locations = Location.all
      @checkins = current_user.checkins
    else
      redirect_to root_url
    end
  end
  
  def show
    if @location = Location.find_by_hash_code(params[:id])
      if current_user.present?
        create(params[:id])
        @checkins = current_user.checkins
        @locations = Location.all
      else
        session[:snapback] = url_for(@location)
        redirect_to root_url
      end
    else
      flash[:notice] = "Error: Location Not Found."
      redirect_to locations_path
    end
  end
  
  def create(hash_code)
      if current_user.present?
        @location = Location.find_by_hash_code(hash_code)
        @checkins = current_user.checkins      
        if @checkins.count == 0 && @location.id != 1
          redirect_to "/oops"
        else
          @checkin = Checkin.new(:user => current_user, :location => @location)
          unless current_user.locations.exists?(@location)
            @checkin.save
          end
        end
      else
        session[:snapback] = url_for(@location)
        redirect_to root_url
      end
  end
  
end
