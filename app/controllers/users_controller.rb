class UsersController < ApplicationController
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to new_group_url
    else
      return render 'edit'
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :avatar)
    end
end