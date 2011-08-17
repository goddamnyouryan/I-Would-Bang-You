class Message < ActiveRecord::Base
  belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"
  
  has_many :responses, :dependent => :destroy
  
  after_create :send_new_message_email
  
  def send_new_message_email
    @user1 = self.sender
    @user2 = self.receiver
    UserMailer.rating_match(@user1, @user2, self).deliver
    UserMailer.rating_match(@user2, @user1, self).deliver
  end
end
