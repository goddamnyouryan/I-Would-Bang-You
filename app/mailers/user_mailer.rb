class UserMailer < ActionMailer::Base
  default :from => "no-reply@iwouldbangyou.com"
  layout 'email'
  
  def rating_match(user, mate, message)
    @user = user
    @mate = mate
    @message = message
    mail(:to => "#{user.email}",
         :subject => "#{mate.login} totally thinks you're bangable too!", :from => "IWouldBangYou")
  end
  
  def sent_response(user, mate, response)
    @user = user
    @mate = mate
    @response = response
    mail(:to => "#{mate.email}",
         :subject => "#{user.login} sent you a message.", :from => "IWouldBangYou")
  end
  
  def contact_form(name, email, message)
    @name = name
    @email = email
    @message = message
    mail(:to => "ryan.macinnes@gmail.com",
         :subject => "IWBY contact form", :from => "IWouldBangYou")
  end
  
end
