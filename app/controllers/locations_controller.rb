class LocationsController < ApplicationController
  
  def show
    if current_user.present?
      create(params[:id])
      @checkins = current_user.checkins
      @locations = Locations.all
    else
      redirect_to root_url
    end
  end
  
  def create(hash_code)
    if current_user.present?
      @location = Locations.find_by_hash_code(hash_code)
      @current_location_id = @location.id.to_s
      
      if @checkins = current_user.checkins.count == 0 && @location.id != 1
        redirect_to "/oops"
      else
        @checkin = Checkin.new
        @checkin.user_id = current_user.id
        @checkin.location_id = @location.id
    
        unless current_user.checkins.find_by_location_id(@location.id).present?
          @checkin.save
        end
      end
    else
      redirect_to root_url
    end
  end
  
end
