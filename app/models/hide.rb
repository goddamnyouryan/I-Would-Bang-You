class Hide < ActiveRecord::Base
  belongs_to :user
  belongs_to :hidden_user, :class_name => 'User', :foreign_key => "hidden_id"
end
