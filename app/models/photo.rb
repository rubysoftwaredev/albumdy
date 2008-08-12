class Photo < ActiveRecord::Base
  
  belongs_to :album, :counter_cache => true
  acts_as_list :scope => :album
  
  has_attached_file :image, 
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/amazon_s3.yml",
                    :path => ":attachment/:id/:style.:extension",
                    :bucket => 'albumdy',
                    :styles => { :medium => "300x300>", :album_cover => '180x180>', :thumb => "100x100>" }
  
  validates_attachment_presence :image
  validates_attachment_content_type :image, :content_type => 'image/jpeg'
  
  # Fix the mime types. Make sure to require the mime-types gem
  def swfupload_file=(data)
    data.content_type = MIME::Types.type_for(data.original_filename).to_s
    self.image = data
  end

end
