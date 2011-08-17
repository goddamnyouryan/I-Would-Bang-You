class Photo < ActiveRecord::Base
  belongs_to :user
  has_attached_file :photo, :styles => { 
                            :tiny => {:geometry => "30x30#", :processors => [:cropper]},
                            :thumb => {:geometry => "90x90#", :processors => [:cropper]}, 
                            :large => {
                              :processors => [:watermark],
                              :geometry => "600x600>", 
                              :watermark_path => "#{RAILS_ROOT}/public/images/watermark.png",
                              :position => 'SouthWest'
                              }
                            },
                            :storage => :s3, 
                            :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", 
                            :path => ':id/:style'

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_photo, :if => :cropping?  
  
  def cropping?  
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?  
  end
  
  def photo_geometry(style = :original)  
    @geometry ||= {}  
    @geometry[style] ||= Paperclip::Geometry.from_file(photo.to_file(style))  
  end
  
  private  
  
  def reprocess_photo
    photo.reprocess!
  end
  
end
