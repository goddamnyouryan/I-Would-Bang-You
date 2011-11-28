class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [ :index, :check_login ]
  def index
    if user_signed_in?
      @similar = current_user.matches.limit(10).near([current_user.latitude, current_user.longitude], 30).sort_by(&:ratio) - current_user.hidden_users - current_user.to_a
      @random = (current_user.browse.limit(10).near([current_user.latitude, current_user.longitude], 30) - current_user.hidden_users - current_user.to_a)
      @random = @random.sort { rand }
    else
      render :layout => "splash"
    end
  end

  def show
    @user = User.find_by_login(params[:id])
    @photo = Photo.new
  end
  
  def search
    @options_for_distance = [["10 miles", 10], ["25 miles", 25], ["100 miles", 100], ["anywhere", 5000]]
    @options_for_order_by = [["Similarity","similarity"], ["Hotness", "hotness"], ["Newest","newest"], ["Distance","distance"]]
    @results = current_user.matches.near([current_user.latitude, current_user.longitude], 25).sort_by(&:ratio) - current_user.hidden_users
    if params[:commit]
      if params[:min_age] && !params[:min_age].blank?
        @min_age = params[:min_age].to_i.years.ago
      else
        @min_age = 18.years.ago
      end
      if params[:max_age] && !params[:max_age].blank?
        @max_age = params[:max_age].to_i.years.ago
      else
        @max_age = 70.years.ago
      end
      if params[:order_by] == "hotness"
         @results = current_user.matches.where("birthday >= ? AND birthday <= ?", @max_age, @min_age).near([current_user.latitude, current_user.longitude], params[:distance]).sort_by(&:score).reverse - current_user.hidden_users
      elsif params[:order_by] == "similarity"
         @results = current_user.matches.where("birthday >= ? AND birthday <= ?", @max_age, @min_age).near([current_user.latitude, current_user.longitude], params[:distance]).sort_by(&:ratio) - current_user.hidden_users
      elsif params[:order_by] == "newest"
         @results = current_user.matches.where("birthday >= ? AND birthday <= ?", @max_age, @min_age).near([current_user.latitude, current_user.longitude], params[:distance]).order("created_at DESC") - current_user.hidden_users
      elsif params[:order_by] == "distance"
         @results = current_user.matches.where("birthday >= ? AND birthday <= ?", @max_age, @min_age).near([current_user.latitude, current_user.longitude], params[:distance]).sort_by(&:distance_sort) - current_user.hidden_users
      end
    end
  end
  
  def browse
    @user = (current_user.matches - current_user.mates - current_user.hidden_users).sample
    if @user.nil?
      @users = current_user.matches.offset(rand(current_user.matches.count)) - current_user.hidden_users
      @user = @users.first
    end
  end
  
  def about
    @user = User.find_by_login(params[:user_id])
    @photo = Photo.new
    render :show
  end
  
  def answer_questions
    @user = User.find_by_login(params[:user_id])
    unless @user == current_user
      redirect_to root_path
    end
  end
  
  def questions
    current_user.update_attributes(params[:user])
    redirect_to user_about_path(current_user.login)
  end
  
  def check_login
    @user = User.where("LOWER(login) = ?", params[:user][:login].downcase)
    if @user == []
      @user = nil
    end
    respond_to do |format|
      format.json { render :json => !@user }
    end
  end

end
