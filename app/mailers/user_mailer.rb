class UserMailer < ActionMailer::Base
  default :from => "no-reply@iwouldbangyou.com"
  
  def rating_match(user, mate, message)
    @user = user
    @mate = mate
    @message = message
    mail(:to => "#{user.email}",
         :subject => "#{mate.login} totally thinks you're bangable too!", :from => "IWouldBangYou")
  end
end
