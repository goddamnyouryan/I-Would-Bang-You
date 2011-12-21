class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :sex, :looking_for_men, 
                  :looking_for_women, :birthday, :zip, :latitude, :longitude, :login, :email_match, 
                  :email_message

  cattr_accessor :current_user, :terms
  
  validates :login, :presence => true, :length => {:minimum => 3}, :uniqueness => { :case_sensitive => false }, :on => :create
  validates :zip, :presence => true, :length => { :is => 5 }
  validates :birthday, :date => { :before => 18.years.ago - 1.day }
  validates :sex, :presence => true
  validate :looking_for_checkboxes

  has_many :photos
  has_many :ratings
  has_many :questions
  
  has_many :visits
  has_many :visitors, :through => :visits
  has_many :viewed, :foreign_key => "visitor_id", :class_name => "Visit"
  
  has_many :mates, :through => :ratings
  has_many :sent, :foreign_key => "sender_id", :class_name => "Message", :dependent => :destroy
  has_many :received, :foreign_key => "receiver_id", :class_name => "Message", :dependent => :destroy
  
  has_many :replys, :foreign_key => "sender_id", :class_name => "Response", :dependent => :destroy
  has_many :replyees, :foreign_key => "receiver_id", :class_name => "Response", :dependent => :destroy
  
  has_many :hides
  has_many :hidden_users, :through => :hides
  
  geocoded_by :zip
  after_validation :geocode, :reverse_geocode
  after_create :default_questions
  
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      obj.city = geo.city
      obj.state = geo.state
    end
  end
  
  def default_questions
    self.questions.create(:question => "If you had to be apart of the apocalypse, what kind of apocalypse would you want it to be?", :kind => "apocalypse")
    self.questions.create(:question => "What was the best place you ever traveled to?", :kind => "travel")
    self.questions.create(:question => "What was your favorite class in highschool or college?", :kind => "favorite_class")
  end

  def ratio
    ((self.score.to_f/self.rating_count) - (current_user.score.to_f/current_user.rating_count)).abs
  end
  
  def distance_sort
    self.distance_to(current_user.to_coordinates).round
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
  
  def singular_pronoun
    if self.sex == "Male"
      "He"
    elsif self.sex == "Female"
      "She"
    end
  end
  
  def looking_for_colloquial
    if self.looking_for_men == true && self.looking_for_women == true
      "guys & girls"
    elsif self.sex == "Male" && self.looking_for_men == true
      "guys"
    elsif self.sex == "Female" && self.looking_for_women == true
      "girls"
    elsif self.sex == "Female" && self.looking_for_men == true
      "guys"
    elsif self.sex == "Male" && self.looking_for_women == true
      "girls"
    else
      "peeps"
    end
  end
  
  def looking_for_colloquial_singular
    if self.looking_for_men == true && self.looking_for_women == true
      "guy or girl"
    elsif self.sex == "Male" && self.looking_for_men == true
      "guy"
    elsif self.sex == "Female" && self.looking_for_women == true
      "girl"
    elsif self.sex == "Female" && self.looking_for_men == true
      "guy"
    elsif self.sex == "Male" && self.looking_for_women == true
      "girl"
    else
      "person"
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
  
  def nav_photo
    @photo = Photo.find :all, :conditions => ["user_id = ? AND profile = ?", self.id, true]
    if @photo.empty?
      if self.photos.first.nil?
        "missing-tiny.png"
      else
        self.photos.first.photo.url(:tiny)
      end
    else
      @photo.first.photo.url(:tiny)
    end
  end
  
  def browse
    if self.looking_for_men == true && self.looking_for_women == true
      if self.sex == "Male"
        @browse = User.where("looking_for_men = ?", true)
      elsif self.sex == "Female"
        @browse = User.where("looking_for_women = ?", true)
      end
    elsif self.sex == "Male" && self.looking_for_men == true
      @browse = User.where("looking_for_men = ? AND sex = ?", true, "Male")
    elsif self.sex == "Female" && self.looking_for_women == true
      @browse = User.where("looking_for_women = ? AND sex = ?", true, "Female")
    else
      if self.sex == "Male"
        @browse = User.where("looking_for_men = ? AND sex = ?", true, "Female")
      elsif self.sex == "Female"
        @browse = User.where("looking_for_women = ? AND sex = ?", true, "Male")
      end
    end
  end
  
  def matches
    if self.looking_for_men == true && self.looking_for_women == true
      if self.sex == "Male"
        User.where("looking_for_men = ?", true)
      elsif self.sex == "Female"
        User.where("looking_for_women = ?", true)
      end
    elsif self.sex == "Male" && self.looking_for_men == true
      User.where("looking_for_men = ? AND sex = ?", true, "Male")
    elsif self.sex == "Female" && self.looking_for_women == true
      User.where("looking_for_women = ? AND sex = ?", true, "Female")
    else
      if self.sex == "Male"
        User.where("looking_for_men = ? AND sex = ?", true, "Female")
      elsif self.sex == "Female"
        User.where("looking_for_women = ? AND sex = ?", true, "Male")
      end
    end
  end
  
  def visited
    self.viewed.map(&:user)
  end
  
  def update_score(score)
    self.score = self.score + score
    self.rating_count = self.rating_count + 1
    self.save!
  end
  
  def destroy_score(score)
    self.score = self.score + score
    self.rating_count = self.rating_count - 1
    self.save!
  end
  
  def update_with_password(params={}) 
    if params[:password].blank? 
      params.delete(:password) 
      params.delete(:password_confirmation) if 
      params[:password_confirmation].blank? 
    end 
    update_attributes(params) 
  end
  
  def self.find_for_authentication(warden_conditions)
     conditions = warden_conditions.dup
     login = conditions.delete(:login)
     where(conditions).where(["lower(login) = :value OR lower(email) = :value", { :value => login.downcase }]).first
   end
  
  def looking_for_checkboxes
    errors.add(:base, "Please check at least one 'looking for' checkbox.") unless looking_for_men || looking_for_women
  end
  
end
