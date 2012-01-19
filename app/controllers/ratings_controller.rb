class RatingsController < ApplicationController
  before_filter :authenticate_user!
  after_filter :update_score, :only => [:create, :browse_rate]
  after_filter :destroy_score, :only => :destroy
  
  def create
    @user = User.find params[:user_id]
    @rating = Rating.create(:user_id => current_user.id, :mate_id => params[:user_id], :status => params[:status])
    @mate = User.find params[:user_id]
    if @rating.save
      if @rating.status == "nope"
        respond_to do |format|
          format.js
          format.html { redirect_to user_path(@user.login), :notice => "Eww, they are gross. They shant be contacting you, no worries." }
        end
      elsif Rating.where("user_id = ? AND mate_id = ? AND status != ?", @user.id, current_user.id, "nope").empty?
        UserMailer.rated(current_user, @mate, @rating.status).deliver if @mate.email_rating?
        respond_to do |format|
          format.js
          format.html { redirect_to user_path(@user.login), :notice => "You have rated this person." }
        end
      else
        @message = Message.create(:sender_id => current_user.id, :receiver_id => params[:user_id])
        @response = Response.create(:message_id => @message.id, :sender_id => current_user.id, :receiver_id => current_user.id, :origin => "robot", :content => "Hey #{@message.sender.login} and #{@message.receiver.login}...it seems you two are totally into each other.  You can message each other from here.  So do it already!")
        @response = Response.create(:message_id => @message.id, :sender_id => @user.id, :receiver_id => @user.id, :origin => "robot", :content => "Hey #{@message.sender.login} and #{@message.receiver.login}...it seems you two are totally into each other.  You can message each other from here.  So do it already!")
        respond_to do |format|
          format.js
          format.html { redirect_to user_path(@user.login), :notice => "You both like each other! Send #{@user.pronoun} a message!" }
        end
      end
    end
  end
  
  def browse_rate
    @user = User.find params[:user_id]
    @rating = Rating.create(:user_id => current_user.id, :mate_id => params[:user_id], :status => params[:status])
    @mate = User.find params[:user_id]
    if @rating.save
      if @rating.status == "nope"
        redirect_to random_path(@user.login), :notice => "Agreed. #{@user.login} IS gross. They won't contact you. Ugh."
      elsif Rating.where("user_id = ? AND mate_id = ? AND status != ?", @user.id, current_user.id, "nope").empty?
        UserMailer.rated(current_user, @mate, @rating.status).deliver if @mate.email_rating?
        redirect_to random_path, :notice => "You have rated #{@user.login}. We'll let you know if they feel the same."
      else
        @message = Message.create(:sender_id => current_user.id, :receiver_id => params[:user_id])
        @response = Response.create(:message_id => @message.id, :sender_id => current_user.id, :receiver_id => current_user.id, :origin => "robot", :content => "Hey #{@message.sender.login} and #{@message.receiver.login}...it seems you two are totally into each other.  You can message each other from here.  So do it already!")
        @response = Response.create(:message_id => @message.id, :sender_id => @user.id, :receiver_id => @user.id, :origin => "robot", :content => "Hey #{@message.sender.login} and #{@message.receiver.login}...it seems you two are totally into each other.  You can message each other from here.  So do it already!")
        redirect_to user_path(@user.login), :notice => "You both like each other! Send #{@user.pronoun} a message!"
      end
    end
  end

  def destroy
    @user = User.find params[:user_id]
    @rating = Rating.find params[:id]
    @rating.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to user_path(@user.login), :notice => "How do you feel about #{@user.login} now?" }
    end
  end
  
  def update_score
    if @rating.status == "nope"
      @mate.update_score(-1)
    elsif @rating.status == "date"
      @mate.update_score(2)
    elsif @rating.status == "bang"
      @mate.update_score(1)
    end
  end
  
  def destroy_score
    if @rating.status == "nope"
      @user.destroy_score(1)
    elsif @rating.status == "date"
      @user.destroy_score(-2)
    elsif @rating.status == "bang"
      @user.destroy_score(-1)
    end
    @rating.destroy
  end

end
