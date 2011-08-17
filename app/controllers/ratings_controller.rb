class RatingsController < ApplicationController
  after_filter :update_score, :only => :create
  
  def create
    @user = User.find params[:user_id]
    @rating = Rating.create(:user_id => current_user.id, :mate_id => params[:user_id], :status => params[:status])
    @mate = User.find params[:user_id]
    if @rating.save
      if @rating.status == "nope"
        redirect_to @user, :notice => "Eww, they are gross. They shant be contacting you, no worries."
      elsif Rating.where("user_id = ? AND mate_id = ? AND status != ?", @user.id, current_user.id, "nope").empty?
        redirect_to @user, :notice => "You have rated this person."
      else
        @message = Message.create(:sender_id => current_user.id, :receiver_id => params[:user_id])
        @response = Response.create(:message_id => @message.id, :sender_id => current_user.id, :receiver_id => current_user.id, :origin => "robot", :content => "Hey #{@message.sender.login} and #{@message.receiver.login}...it seems you two two are totally into each other.  You can message each other from here.  So do it already!")
        @response = Response.create(:message_id => @message.id, :sender_id => @user.id, :receiver_id => @user.id, :origin => "robot", :content => "Hey #{@message.sender.login} and #{@message.receiver.login}...it seems you two two are totally into each other.  You can message each other from here.  So do it already!")
        redirect_to @user, :notice => "You both like each other! Send #{@user.pronoun} a message!"
      end
    end
  end

  def destroy
    @user = User.find params[:user_id]
    @rating = Rating.find params[:id]
    @rating.destroy
    redirect_to @user, :notice => "How do you feel about #{@user.login} now?"
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

end
