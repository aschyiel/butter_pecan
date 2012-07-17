include Rails.application.routes.url_helpers

class ComicStrip < ActiveRecord::Base
  attr_accessible :content, :title, :thumbnail

  validates( :title, presence: true, uniqueness: { case_sensitive: false } ) 

  #
  # return the relative comic sequence number of this strip.
  # 
  def get_number()
    strip = self; 
    previous = ComicStrip.where( "id < ?", strip.id );  # TODO I'm sure this could be cached for a minor performance boost...
    return previous.size + 1;
  end

  #
  # return a url link to this comic strip.
  #
  def get_my_link()
    strip = self;
    return "comic/#{strip.id}"; # this utilizes our route magic 
                          # to forward us to home/index/:id 
  end 

  #
  # return a formatted date representing our comicStrips' creation date.
  # uses my favourite date formatting style of ddmmyy (ie. july 16th 2012 --> 160712).
  #
  def get_date()
    strip = self;
    return strip.created_at.strftime( "%d%m%y" );
  end

end
