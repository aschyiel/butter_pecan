
require 'rexml/document'
require 'rexml/formatters/pretty'

class FeederController < ApplicationController

  respond_to :xml; 

  #
  # see http://paulsturgess.co.uk/articles/13-creating-an-rss-feed-in-ruby-on-rails
  # http://guides.rubyonrails.org/layouts_and_rendering.html
  #
  def rss
    strips = ComicStrip.find( :all, 
        :order => "id DESC", 
        :limit => 10 );

    @rss_xml = get_rss_xml( strips ); 

#   respond_with( 
      render( 
          :xml => @rss_xml,
          :content_type => 'application/rss',
          :layout => false ) 
#   );
#   end
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
    make_elem = Proc.new do | tag_name, elem_text |
      elem = REXML::Element.new( tag_name );
      elem.add_text( REXML::Text.new( elem_text ) ) if elem_text;
      return elem;
    end

    channel = REXML::Element.new( 'channel' );
#   channel.add_element( 'title', { 'text' => 'butter_pecan' } );
    channel.add_element( make_elem.call( 'title', :butter_pecan ) );
    channel.add_element( 'description', 
        { 'text' => 'an experimental html5 webcomic by Ulysses Levy.' } );
    channel.add_element( 'link', 
        { 'text' => url_for( 'http://'+request.host ) } );

#   channel.add_element( 'lastBuildDate', { 'text' => Time.now.to_s } );
#   channel.add_element( 'pubDate', { 'text' => Time.now.to_s } );

    strips.each do |strip|
      item = REXML::Element.new( 'item' );

      item.add_element( 'title', { 'text' => strip.title } );
      item.add_element( 'description', { 'text' => strip.title } ); # TODO description
      item.add_element( 'link', { 'text' => 
          url_for( :only_path => false, 
              :controller => 'home', 
              :action =>     'index', 
              :id =>         strip.id ) } );
      item.add_element( 'guid', { 'text' => strip.id.to_s } );
      item.add_element( 'pubDate', { 'text' => strip.created_at.to_s } );

      channel.add_element item;
    end

    rss = REXML::Element.new 'rss';  
    rss.add_attribute( 'version', '2.0' );
    rss.add_element channel;
    doc.add( rss );
    xml = []
    formatter = REXML::Formatters::Pretty.new
    formatter.write( doc, xml );
    return xml.join("");
  end

end
