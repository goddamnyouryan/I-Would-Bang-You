# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# 1000.times do
#   User.create(
#     :email => Faker::Internet.email,
#     :password => "garbage",
#     :password_confirmation => "garbage",
#     :login =>Faker::Internet.user_name.gsub(".","-"),
#     :sex => ["Male", "Female"].shuffle.first,
#     :looking_for_men => [true,false].shuffle.first,
#     :looking_for_women => [true,false].shuffle.first,
#     :birthday => (6570..18250).to_a.rand.days.ago,
#     :zip => Faker::Address.zip_code,
#     :email_match => false,
#     :email_message => false,
#     :apocalypse => Faker::Lorem.paragraph([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20].shuffle.first),
#     :travel => Faker::Lorem.paragraph([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20].shuffle.first),
#     :favorite_class => Faker::Lorem.paragraph([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20].shuffle.first)
#   )
# end
# 
# @no_location = User.where("latitude IS NULL")
# @no_location.each do |user|
#   user.destroy
# end

# User.all.each do |user|
#   user.questions.create(:question => "If you had to be apart of the apocalypse, what kind of apocalypse would you want it to be?", :kind => "apocalypse")
#   user.questions.create(:question => "What was the best place you ever traveled to??", :kind => "travel")
#   user.questions.create(:question => "What was your favorite class in highschool or college?", :kind => "favorite_class")
# end

# Rating.all.each do |rating|
#   if rating.status != "nope"
#     unless rating.user.nil? || rating.mate.nil?
#       UserMailer.rated(rating.user, rating.mate, rating.status).deliver if rating.mate.email_rating?
#     end
#   end
# end

@no_photos = User.all - User.joins(:photos).uniq
@no_ratings = User.all - User.joins(:ratings).uniq
@no_answers = User.all - User.joins(:questions).where("questions.answer IS NOT NULL").uniq
@users = (@no_photos + @no_ratings + @no_answers).uniq
@users.each do |user|
  UserMailer.reminder(user).deliver
end 