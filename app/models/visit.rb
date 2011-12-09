class Visit < ActiveRecord::Base
  belongs_to :user
  belongs_to :visitor, :class_name => 'User', :foreign_key => "visitor_id"
end
