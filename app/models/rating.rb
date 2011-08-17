class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :mate, :class_name => 'User', :foreign_key => "mate_id"
end
