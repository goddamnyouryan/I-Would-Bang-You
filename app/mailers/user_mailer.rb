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
  
  def rated(user, mate, status)
    @user = mate
    @mate = user
    @status = status
    mail(:to => "#{@user.email}",
         :subject => "#{@mate.login} would #{@status} you!", :from => "IWouldBangYou")
  end
  
  def reminder(user)
    @user = user
    @matches = (@user.matches.joins(:photos).near(@user, 5000, :order => "distance").limit(10) - @user.hidden_users - User.where("id = ?", @user.id)).uniq
    mail(
      :to => "#{@user.email}",
      :subject => "Finish your profile up!", :from => "IWouldBangYou"
    )
  
end
