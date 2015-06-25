class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  def home
    render layout: "landing"
  end
  
  def authenticate_current_user!
    if session[:user_id].blank?
      flash[:info] = "Please sign in with twitter to access this page"
      return redirect_to root_url 
    end
  end
  
  private
    def current_user
      begin
        User.find(session[:user_id]) unless session[:user_id].blank?
      rescue ActiveRecord::RecordNotFound
        session[:user_id]=nil
      end
    end
end
