class ResponsesController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    @message = Message.find params[:message_id]
    if current_user == @message.sender
      @response = Response.create(:message_id => @message.id, :sender_id => current_user.id, :receiver_id => @message.receiver_id, :content => params[:response][:content])
    elsif current_user == @message.receiver
      @response = Response.create(:message_id => @message.id, :sender_id => current_user.id, :receiver_id => @message.sender_id, :content => params[:response][:content])
    end
    if @response.save
      respond_to do |format|
        format.js
        format.html { redirect_to @message, :notice => "Message Sent!" }
      end
    end
  end

  def destroy
  end

end
