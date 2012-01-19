class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [ :index, :check_login, :contact, :send_contact, :learn_more ]
  after_filter :add_visit, :only => [:show, :random]
  
  def index
    if user_signed_in?
      @similar = current_user.matches.limit(10).near([current_user.latitude, current_user.longitude], 30).sort_by(&:ratio) - current_user.hidden_users - User.where("id = ?", current_user.id)
      if @similar.count < 10
        @left = 10 - @similar.count
        @similar = (@similar + (current_user.matches.near(current_user, 5000, :order => "distance").limit(@left) - current_user.hidden_users - User.where("id = ?", current_user.id))).uniq
      end
      @random = (current_user.browse.limit(10).near([current_user.latitude, current_user.longitude], 30) - current_user.hidden_users - User.where("id = ?", current_user.id))
      if @random.count < 10
        @left = 10 - @random.count
        @random = (@random + (current_user.matches.near(current_user, 5000, :order => "distance").limit(@left) - current_user.hidden_users - User.where("id = ?", current_user.id))).uniq
      end
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
    if current_user.looking_for_colloquial == "guys"
      @options_for_sex = [["Men", "Male"], ["Women", "Female"], ["Both", "both"]]
    elsif current_user.looking_for_colloquial == "girls"
      @options_for_sex = [["Women", "Female"], ["Men", "Male"], ["Both", "both"]]
    elsif current_user.looking_for_colloquial == "guys & girls"
      @options_for_sex = [["Women", "Female"], ["Men", "Male"], ["Both", "both"]]
    else
      @options_for_sex = [["Women", "Female"], ["Men", "Male"], ["Both", "both"]]
    end
    @options_for_distance = [["10 miles", 10], ["25 miles", 25], ["100 miles", 100], ["anywhere", 5000]]
    @options_for_order_by = [["Similarity","similarity"], ["Hotness", "hotness"], ["Newest","newest"], ["Distance","distance"]]
    @results = (current_user.matches.near(current_user, 1000, :order => "distance") - current_user.hidden_users)
    @results = Kaminari.paginate_array(@results).page(params[:page]).per(10)
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
        if params[:sex] == "both"
          @results = User.where("birthday >= ? AND birthday <= ?", @max_age, @min_age).near([current_user.latitude, current_user.longitude], params[:distance]).sort_by(&:score).reverse - current_user.hidden_users
        else
          @results = User.where("birthday >= ? AND birthday <= ? AND sex = ?", @max_age, @min_age, params[:sex]).near([current_user.latitude, current_user.longitude], params[:distance]).sort_by(&:score).reverse - current_user.hidden_users
        end
        if params[:mates] == "on"
          @results = @results - current_user.mates
        end
        @results = Kaminari.paginate_array(@results).page(params[:page]).per(10)
      elsif params[:order_by] == "similarity"
        if params[:sex] == "both"
          @results = User.where("birthday >= ? AND birthday <= ?", @max_age, @min_age).near([current_user.latitude, current_user.longitude], params[:distance]).sort_by(&:ratio) - current_user.hidden_users
        else
          @results = User.where("birthday >= ? AND birthday <= ? AND sex = ?", @max_age, @min_age, params[:sex]).near([current_user.latitude, current_user.longitude], params[:distance]).sort_by(&:ratio) - current_user.hidden_users
        end
        if params[:mates] == "on"
          @results = @results - current_user.mates
        end
        @results = Kaminari.paginate_array(@results).page(params[:page]).per(10)
      elsif params[:order_by] == "newest"
        if params[:sex] == "both"
          @results = User.where("birthday >= ? AND birthday <= ?", @max_age, @min_age).near([current_user.latitude, current_user.longitude], params[:distance]).order("created_at DESC") - current_user.hidden_users
        else
          @results = User.where("birthday >= ? AND birthday <= ? AND sex = ?", @max_age, @min_age, params[:sex]).near([current_user.latitude, current_user.longitude], params[:distance]).order("created_at DESC") - current_user.hidden_users
        end
        if params[:mates] == "on"
          @results = @results - current_user.mates
        end
        @results = Kaminari.paginate_array(@results).page(params[:page]).per(10)
      elsif params[:order_by] == "distance"
        if params[:sex] == "both"
          @results = User.where("birthday >= ? AND birthday <= ?", @max_age, @min_age).near([current_user.latitude, current_user.longitude], params[:distance]).sort_by(&:distance_sort) - current_user.hidden_users
        else
          @results = User.where("birthday >= ? AND birthday <= ? AND sex = ?", @max_age, @min_age, params[:sex]).near([current_user.latitude, current_user.longitude], params[:distance]).sort_by(&:distance_sort) - current_user.hidden_users
        end
        if params[:mates] == "on"
          @results = @results - current_user.mates
        end
        @results = Kaminari.paginate_array(@results).page(params[:page]).per(10)
      end
    end
  end
  
  def random
    @user = (current_user.matches.near(current_user, 1000, :order => "distance") - current_user.mates - current_user.hidden_users)
    @user = @user[0..5].sample
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
  
  def history 
    if params[:mates] == "matches"
      @rated = current_user.mates.where("status = ?", "bang")
      @history = Array.new
      @rated.each do |user|
        if user.mates.include?(current_user)
          @history << user
        end
      end
      @count = @history.count
      @history = Kaminari.paginate_array(@history).page(params[:page]).per(10)
    elsif params[:mates] == "bang"
      @history = current_user.mates.where("status = ?", "bang")
      @count = @history.count
      @history = Kaminari.paginate_array(@history).page(params[:page]).per(10)
    elsif params[:mates] == "date"
      @history = current_user.mates.where("status = ?", "date")
      @count = @history.count
      @history = Kaminari.paginate_array(@history).page(params[:page]).per(10)
    elsif params[:mates] == "nope"
      @history = current_user.mates.where("status = ?", "nope")
      @count = @history.count
      @history = Kaminari.paginate_array(@history).page(params[:page]).per(10)
    else
      @history = current_user.mates
      @count = @history.count
      @history = Kaminari.paginate_array(@history).page(params[:page]).per(10)
    end
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
  
  def learn_more 
    render :layout => "splash"
  end
  
  def contact 
    render :layout => "splash"
  end
  
  def send_contact
    UserMailer.contact_form(params[:name], params[:email], params[:message]).deliver
    redirect_to root_path, :notice => "Your Message was sent!"
  end
  
  private
  
  def add_visit
    unless current_user == @user || @user.nil?
      @user.visits.create(:visitor_id => current_user.id)
    end
  end

end
