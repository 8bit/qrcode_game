class CheckinsController < ApplicationController
  def index
    @checkins = Checkin.all
  end
  
  def download_xls
    if current_user
      session[:snapback] = nil
      if current_user.is_admin?
        book = Spreadsheet::Workbook.new

        sheet = book.create_worksheet :name => 'Checkins'
        sheet.row(0).concat %w{ID Name Provider Nickname Location Timestamp }
        Checkin.all.each_with_index do |checkin,index|
          sheet.row(index+1).concat [checkin.id, checkin.user.user_info['name'], checkin.user.authorizations.first.provider, checkin.user.user_info['nickname'], checkin.location.name, checkin.created_at.in_time_zone("Central Time (US & Canada)").to_s(:standard)]
        end
        
        sheet_locations = book.create_worksheet :name => 'Locations'
        sheet_locations.row(0).concat %w{ID Name Checkins }
        Location.all.each_with_index do |location,index|
          sheet_locations.row(index+1).concat [location.id, location.name, location.checkins.count]
        end
        
        sheet_users = book.create_worksheet :name => 'Users'
        sheet_users.row(0).concat %w{ID Name Provider Nickname Email Checkins }
        User.all.each_with_index do |user,index|
          sheet_users.row(index+1).concat [user.id, user.user_info['name'], user.authorizations.first.provider, user.user_info['nickname'], user.user_info['email'], user.checkins.count]
        end
        
        
        blob = StringIO.new("")
        book.write blob
        
        send_data blob.string, :type => :xls, :filename => "checkins"+Time.now.to_s(:number)+".xls"
      else
        render :text => "You do not have permission to do this action. Please go to http://wrightsmediagame.com/signout and then log back in as an authorized user."
      end
    else
      session[:snapback] = "/download_xls"
      redirect_to root_url
    end
  end
end
