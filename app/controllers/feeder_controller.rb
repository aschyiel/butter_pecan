
require 'rexml/document'
require 'rexml/formatters/pretty'

class FeederController < ApplicationController

  respond_to :xml; 
  
  #
  # setup caching for our site's feeds.
  #
  # refs:
  #   https://devcenter.heroku.com/articles/caching-strategies 
  #   http://guides.rubyonrails.org/caching_with_rails.html
  #
  caches_action( :rss, :expires_in => 12.hours );

  #
  # see http://paulsturgess.co.uk/articles/13-creating-an-rss-feed-in-ruby-on-rails
  # http://guides.rubyonrails.org/layouts_and_rendering.html
  #
  def rss
    strips = ComicStrip.find( :all, 
        :order => "id DESC", 
        :limit => 10 );

    @rss_xml = get_rss_xml( strips ); 

    render( 
        :xml => @rss_xml,
        :content_type => 'application/rss',
        :layout => false ) 
  end 

  #--------------------------------------------------
  # 
  private
  #
  #--------------------------------------------------

  def title
    "butter_pecan"
  end

  def description
    return "an experimental html5 webcomic by Ulysses Levy.";
  end 

  def site_link
    return url_for( 'http://'+request.host );
  end

  #
  # return the rss xml string representation of some comic strips.
  #
  # references:
  #   rexml docs at http://www.ruby-doc.org/stdlib-1.9.3/libdoc/rexml/rdoc/REXML/Element.html
  #   http://stackoverflow.com/questions/3883349/rubyonrails-url-for-application-root
  #
  def get_rss_xml( strips )
    doc = REXML::Document.new();
    doc << REXML::XMLDecl.new( "1.0", "UTF-8" );

    # the syntax is rexml is kinda stupid...
    # this closure makes creating a new node with text into a one liner.
    make_elem = lambda do | tag_name, elem_text |
      elem = REXML::Element.new( tag_name );
      elem.add_text( REXML::Text.new( elem_text ) ) if elem_text;
      return elem;
    end

    channel = REXML::Element.new( 'channel' );
    channel.add_element( make_elem.call( 'title', feeder.title ) );
    channel.add_element( make_elem.call( 'description', feeder.description ) );
    channel.add_element( make_elem.call( 'link', feeder.site_link ) );
  
    # TODO lastBuildDate, pubDate

    strips.each do |strip|
      item = REXML::Element.new( 'item' );

      item.add_element( make_elem.call( 'title', strip.title ) );
      item.add_element( make_elem.call( 'description', strip.title ) ); # TODO description
      item.add_element( make_elem.call( 'link', strip.get_link ) );
      item.add_element( make_elem.call( 'guid', strip.id.to_s ) );
      item.add_element( make_elem.call( 'pubDate', strip.created_at.to_s ) );

      channel.add_element item;
    end

    rss = REXML::Element.new 'rss';  
    rss.add_attribute( 'version', '2.0' );
    rss.add_element channel;
    doc.add( rss );
    xml = []
    formatter = REXML::Formatters::Pretty.new
    formatter.write( doc, xml );  # note: write to anything supporting "<<" such as array.
    return xml.join("");
  end

end
