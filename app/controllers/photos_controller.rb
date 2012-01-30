class PhotosController < ApplicationController
  before_filter :authenticate_user!
  
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
    @user = @photo.user
    @photo.update_attributes(params[:photo])
    if @photo.save
      redirect_to user_path(@user.login), :notice => "Photo Cropped!"
    end
  end
  
  def destroy
    @photo = Photo.find params[:id]
    @user = @photo.user
    @photo.destroy
    redirect_to user_path(@user.login), :notice => "Photo Deleted!"
  end
  
  def edit_caption
    @user = User.find params[:user_id]
    @photo = Photo.find params[:photo_id]
    respond_to do |format|
      format.js
    end
  end
  
  def update_caption
    @user = User.find params[:user_id]
    @photo = Photo.find params[:photo_id]
    if params[:caption]
      @photo.update_attributes(:caption => params[:caption])
    end
    respond_to do |format|
      format.js
    end
  end
  
  def make_profile
    @photo = Photo.find params[:photo_id]
    @user = User.find params[:user_id]
    @user.photos.where("profile = ?", true).each do |photo|
      photo.update_attributes(:profile => nil)
    end
    @photo.update_attributes(:profile => true)
    if @photo.save
      redirect_to user_path(@user.login), :notice => "New Profile Photo!"
    end
  end
  
  def sort
    @user = User.find params[:user_id]
    @user.photos.each do |photo|
      photo.position = params['photo'].index(photo.id.to_s) + 1
      photo.save
    end
    respond_to do |format|
      format.js { }
      format.html { redirect_to @video }
    end
  end

end
