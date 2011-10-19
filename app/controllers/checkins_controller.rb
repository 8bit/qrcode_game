class CheckinsController < ApplicationController
  def index
    @checkins = Checkin.all
      
  end
end
