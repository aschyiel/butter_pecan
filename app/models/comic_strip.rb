class ComicStrip < ActiveRecord::Base
  attr_accessible :content, :title

  validates( :title, prence: true, uniqueness: { case_sensitive: false } ) 

end
