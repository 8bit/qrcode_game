class UserSessionsController < ApplicationController
  def new
    unless current_user
      @user_session = UserSession.new
    else
      redirect_to root_url
    end
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully created user session."
      redirect_to root_url
    else
      render :new
    end
  end

  def destroy
    @user_session = UserSession.find(params[:id])
    @user_session.destroy
    flash[:notice] = "Successfully destroyed user session."
    redirect_to signin_path
  end
end
