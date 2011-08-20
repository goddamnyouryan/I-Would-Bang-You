class PhotosController < ApplicationController
  
  def index
    @user = User.find params[:user_id]
    @photo = Photo.new
  end
  
  def create
    @user = User.find params[:user_id]
    @photo = @user.photos.create(params[:photo])
    if @photo.save
      redirect_to user_photo_path(@user, @photo), :notice => "Successfully Uploaded.  Now Crop the Thumbnail."
    end
  end
  
  def show
    @photo = Photo.find params[:id]
    unless current_user.photos.include?(@photo)
      redirect_to root_path, :notice => "Hey! Get out of there! You're not allowed!"
    end
    @user = User.find params[:user_id]
  end
  
  def update
    @photo = Photo.find params[:id]
    @photo.update_attributes(params[:photo])
    if @photo.save
      redirect_to user_photos_path, :notice => "Photo Cropped!"
    end
  end
  
  def destroy
    @photo = Photo.find params[:id]
    @photo.destroy
    redirect_to user_photos_path, :notice => "Photo Deleted."
  end
  
  def make_profile
    @photo = Photo.find params[:photo_id]
    @user = User.find params[:user_id]
    @user.photos.where("profile = ?", true).each do |photo|
      photo.update_attributes(:profile => nil)
    end
    @photo.update_attributes(:profile => true)
    if @photo.save
      redirect_to user_photos_path, :notice => "New Profile Photo!"
    end
  end

end
