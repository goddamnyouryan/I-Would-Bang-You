class Response < ActiveRecord::Base
  belongs_to :message
  
  belongs_to :replyer, :class_name => "User", :foreign_key => "sender_id"
  belongs_to :replyee, :class_name => "User", :foreign_key => "receiver_id"
end
