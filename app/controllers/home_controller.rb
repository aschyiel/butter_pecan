
require 'net/http'
require 'rexml/document'

#
# the Home controller is the "main" thing we interact with;
# as determined by config/routes.rb settings home#index to our web root.
#
class HomeController < ApplicationController

  respond_to :html, :json

  # TODO whitelist attributes

  #
  # methods made we want to make accessible to the view.
  #
# helper_method :show_latest_comic 

  def index 
    logger.debug "..HomeController.index..";
    populate_blog_snippets();
    @title = 'Home';
#   @background_image = 'media/bg_tiles.png';
    @background_image = get_background_image();
  end

  #
  # show the latest/most-recent comic strip,
  # this gets called by the client via ajax.
  #
  def show_latest
    @comicStrip = ComicStrip.find(:last); 
    assert { @comicStrip }
    logger.debug "loading comicStrip: #{@comicStrip}";
#   respond_with( @comicStrip.to_json() );
    respond_with( @comicStrip.content.to_json() );
  end

#---------------------------------------------------------------------------
#
private 
#
#---------------------------------------------------------------------------

  #
  # see http://stackoverflow.com/questions/3264168/how-to-put-assertions-in-ruby-code
  #
  def assert( &block ) 
    raise RuntimeError unless yield;
  end

  #
  # populates @blog_snippets
  # appears in the view as a table of clickable blog entry links.
  #
  def populate_blog_snippets() 
    logger.debug "..HomeController.populate_blog_snippets..";
    response = Net::HTTP.get( URI.parse( 
        'http://www.blogger.com/feeds/149641664597065214/posts/summary' ) );  #..TODO paging?..
    doc = REXML::Document.new( response ); 
    root = doc.root;
    entries = root.elements.each("entry"){ |elem| elem }
    
    li = []; 
    entries.each do |entry| 
      li << { 
          :title =>     entry.elements["title"]    .text.to_s,        #..TODO consider slicing to max title..
          :published => entry.elements["published"].text.to_s[0..9],  #..TODO proper date formating..
          :url =>       get_entry_link( entry ) };
    end 
    @blog_snippets = li.sort_by{ |it| it[ :published ] }.reverse;   # TODO corner case where 2 entries 
                                                                    # from same day...
#   logger.debug "@blog_snippets:#{ @blog_snippets }"
  end
 
  #
  # get a user friendly blog entry link;
  # 1 of like 4 possible links available for t3h entry.
  #
  # @param entry (REXML::Element, aka xml)
  # @return (String) link to a blogSpot entry.
  #
  def get_entry_link( entry )
    title = entry.elements["title"].text.to_s;
    links = entry.elements.each("link"){ |elem| elem };
    link = links.select{ |elem| elem.attribute("title").to_s == title }[0];
    assert { link };
    return link.attribute("href").to_s; 
  end


  #
  # return the path to a background image.
  # The ideal is to give a different/random background to the view everytime.
  # @return string.
  #
  def get_background_image()
    return [
        'media/bg_tiles.png',
        'media/bg2.png'
        ].sample;
  end

end
