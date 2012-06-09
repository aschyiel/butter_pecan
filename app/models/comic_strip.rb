class ComicStrip < ActiveRecord::Base
  attr_accessible :content, :title

  validates( :title, presence: true, uniqueness: { case_sensitive: false } ) 

end
