
require 'net/http'
require 'rexml/document'

#
# the Home controller is the "main" thing we interact with;
# as determined by config/routes.rb settings home#index to our web root.
#
class HomeController < ApplicationController

  respond_to :html, :json

  # TODO whitelist attributes

# helper_method :show_latest_comic 

  #
  # gets called via ajax from the view,
  # asking for the current comic's info (based on session).
  #
  # see http://www.dzone.com/snippets/date-time-format-ruby
  #
  # TODO: is it sloppy to not just include this in addition 
  # to the comic strip json content in the first place?
  #
  def get_current_comic_info
    assert { session[ :strip_id ] }
    strip = ComicStrip.find( session[ :strip_id ] );
    assert { strip }
    data = {};
    data[ :comic_title ] = '"'+strip.title+'"';
    data[ :comic_date ] = strip.created_at.to_time.strftime "%m-%d-%Y";
    respond_with( data );
  end 

  def index 
    logger.debug "..HomeController.index..";

    logger.debug "params[:id]:#{params[:id]}";
    #
    # store our id parameter into our cookie;
    # we will shortly reclaim this when the client asks for 
    # which comic we should show via "show_selected".
    #
    if ( params && params[:id] )
      session[ :strip_id ] = params[ :id ];
    else
      session[ :strip_id ] = ComicStrip.last.id;
    end 

    populate_blog_snippets();
    @title = 'Home';
    @background_image = get_background_image();
  end

  def show_current
    if ( !session[ :strip_id ] )
      return respond_with( nil.to_json );
    end

    begin
      strip = ComicStrip.find( session[:strip_id] );
    rescue
      strip = nil;
    end

    if ( !strip )
      logger.warn( "no comic strip found with id:#{ session[:strip_id] }" );
      return respond_with( nil.to_json );
    end

    respond_with( strip.content.to_json() );  
  end

  #
  # show the latest/most-recent comic strip,
  # this gets called by the client via ajax.
  # (expected to be the first thing the user does).
  #
  def show_latest
    strip = ComicStrip.find(:last); 
    assert { strip }
    session[ :strip_id ] = strip.id;
    respond_with( strip.content.to_json() );
  end

  #
  # show our first comic.
  #
  def show_first
    strip = ComicStrip.find(:first);
    assert { strip }
    logger.debug "loading comicStrip id: #{strip.id}";
    session[ :strip_id ] = strip.id;
    respond_with( strip.content.to_json() ); 
  end

  #
  # show the previous comic based on our session.
  #
  def show_previous
    assert { session[ :strip_id ] }
    strip = ComicStrip.where( "id < ?", session[:strip_id] ).last;
    strip = ComicStrip.first unless strip;
    assert { strip } 
    session[ :strip_id ] = strip.id;
    respond_with( strip.content.to_json() );
  end

  #
  # show the next comic based on our session.
  # see http://stackoverflow.com/questions/7394088/rails-get-next-previous-record
  # 
  def show_next 
    assert { session[ :strip_id ] }
    strip = ComicStrip.where( "id > ?", session[:strip_id] ).first;
    strip = ComicStrip.last unless strip;
    assert { strip } 
    session[ :strip_id ] = strip.id;
    respond_with( strip.content.to_json() );
  end

  #
  # show a random comic.
  # see http://stackoverflow.com/questions/5342270/rails-3-get-random-record
  # TODO prevent "dupes".
  #
  def show_random
    current_id = session[ :strip_id ];
    tries = 0;
    while true do
      strip = ComicStrip.offset( rand( ComicStrip.count ) ).first;
      break unless current_id == strip.id 
      tries += 1;
      break unless tries < 3
    end
    assert { strip } 
    session[ :strip_id ] = strip.id;
    respond_with( strip.content.to_json() ); 
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
#   raise RuntimeError unless yield;
    if ( !yield )
      logger.warn "assert failed:#{block}"; 
    end
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
    link = links.select{ |elem| elem.attribute("title").to_s == title }[0]; #TODO:quotes in the blog title will dork this!!!
    assert { link } 
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
