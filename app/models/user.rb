class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :sex, :looking_for_men, 
                  :looking_for_women, :birthday, :zip, :latitude, :longitude, :login
  
  has_many :photos
  has_many :ratings
  has_many :mates, :through => :ratings
  has_many :sent, :foreign_key => "sender_id", :class_name => "Message"
  has_many :received, :foreign_key => "receiver_id", :class_name => "Message"
  
  has_many :replys, :foreign_key => "sender_id", :class_name => "Response"
  has_many :replyees, :foreign_key => "receiver_id", :class_name => "Response"
  
  geocoded_by :zip
  after_validation :geocode, :reverse_geocode
  
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      obj.city = geo.city
      obj.state = geo.state
    end
  end
  
  def age
    (((Date.today - self.birthday).to_i)/365).round
  end
  
  def pronoun
    if self.sex == "Male"
      "him"
    elsif self.sex == "Female"
      "her"
    end
  end
  
  def looking_for
    if self.looking_for_men == true && self.looking_for_women == true
      "Bisexual"
    elsif self.sex == "Male" && self.looking_for_men == true
      "Gay"
    elsif self.sex == "Female" && self.looking_for_women == true
      "Gay"
    else
      "Straight"
    end
  end
  
  def profile_photo
    @photo = Photo.find :all, :conditions => ["user_id = ? AND profile = ?", self.id, true]
    if @photo.empty?
      if self.photos.first.nil?
        "missing.png"
      else
        self.photos.first.photo.url(:thumb)
      end
    else
      @photo.first.photo.url(:thumb)
    end
  end
  
  def browse
    if self.looking_for_men == true && self.looking_for_women == true
      if self.sex == "Male"
        @browse = User.where("looking_for_men = ?", true).near([self.latitude, self.longitude], 30)
      elsif self.sex == "Female"
        @browse = User.where("looking_for_women = ?", true).near([self.latitude, self.longitude], 30)
      end
    elsif self.sex == "Male" && self.looking_for_men == true
      @browse = User.where("looking_for_men = ? AND sex = ?", true, "Male").near([self.latitude, self.longitude], 30)
    elsif self.sex == "Female" && self.looking_for_women == true
      @browse = User.where("looking_for_women = ? AND sex = ?", true, "Female").near([self.latitude, self.longitude], 30)
    else
      if self.sex == "Male"
        @browse = User.where("looking_for_men = ? AND sex = ?", true, "Female").near([self.latitude, self.longitude], 30)
      elsif self.sex == "Female"
        @browse = User.where("looking_for_women = ? AND sex = ?", true, "Male").near([self.latitude, self.longitude], 30)
      end
    end
  end
  
  def update_score(score)
    self.score = self.score + score
    self.rating_count = self.rating_count + 1
    self.save!
  end
  
end
