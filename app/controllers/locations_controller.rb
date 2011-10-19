class LocationsController < ApplicationController
  
  def show
    create(params[:id])
    @checkins = current_user.checkinss
    @locations = Locations.all
  end
  
  def create(hash_code)
    @location = Locations.find_by_hash_code(hash_code)
    @checkin = Checkins.new
    @checkin.user_id = current_user.id
    @checkin.location_id = @location.id
    
    unless current_user.checkinss.find_by_location_id(@location.id).present?
      @checkin.save
    end
  end
  
end
