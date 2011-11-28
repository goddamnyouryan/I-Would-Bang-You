class Users::RegistrationsController < Devise::RegistrationsController
  layout "splash"
  
  def edit
    render :layout => "application"
  end
end