class Response < ActiveRecord::Base
  belongs_to :message
  
  belongs_to :replyer, :class_name => "User", :foreign_key => "sender_id"
  belongs_to :replyee, :class_name => "User", :foreign_key => "receiver_id"
  
  after_create :send_new_response_email, :update_message_date
  
  def send_new_response_email
    unless self.replyer == self.replyee
      @user = self.replyer
      @mate = self.replyee
      UserMailer.sent_response(@user, @mate, self).deliver if @mate.email_message?
    end
  end
  
  def update_message_date
    self.message.update_attributes(:updated_at => self.created_at)
  end
  
end
