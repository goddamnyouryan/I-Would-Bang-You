class HidesController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    @user = User.find params[:user_id]
    @hide = Hide.create(:user_id => current_user.id, :hidden_id => @user.id)
    if @hide.save
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @user = User.find params[:user_id]
    @hide = Hide.find_by_user_id_and_hidden_id(current_user.id, @user.id)
    @hide.destroy
    respond_to do |format|
      format.js
    end
  end

end
