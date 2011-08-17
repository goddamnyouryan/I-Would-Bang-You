class PhotosController < ApplicationController
  
  def index
    @user = User.find params[:user_id]
    @photo = Photo.new
  end
  
  def create
    @user = User.find params[:user_id]
    @photo = @user.photos.create(params[:photo])
    if @photo.save
      redirect_to user_photo_path(current_user, @photo), :notice => "Successfully Uploaded.  Now Crop the Thumbnail."
    end
  end
  
  def show
    @photo = Photo.find params[:id]
    @user = User.find params[:user_id]
  end
  
  def update
    @photo = Photo.find params[:id]
    @photo.update_attributes(params[:photo])
    if @photo.save
      redirect_to user_photos_path, :notice => "Photo Cropped!"
    end
  end

end
