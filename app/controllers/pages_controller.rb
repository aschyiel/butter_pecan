
class PagesController < ApplicationController
  def gallery 
    setup_view( 'gallery' );
  end

  def archives
    @my_comic_archives = lookup_my_comic_archives();
    setup_view( 'archives' );
  end

  def misc
    setup_view( 'misc' );
  end

  def about 
    setup_view( 'about' );
  end

  private

  #
  # return a list of comics to show up in our archive.
  #
  # each element in the list contains the following properties:
  #   image --- a link to the thumbnail image.
  #   link ---- the actual comic strip link.
  #   title --- the title of the comic. 
  #   number -- the comic number (relative to sequence).
  #   date ---- the date the comic was created
  #
  def lookup_my_comic_archives()
    # TODO use paging
    li = [];
    ComicStrip.all.each do |elem|
#   li = ComicStrip.find(:all).collect do |strip|
#     li << { 
#       :image =>  elem.get_thumbnail(),
#       :link =>   elem.get_my_link(),
#       :title =>  elem.title,
#       :number => elem.get_number(),
#       :date =>   elem.get_date() 
#     }; 
      li << { 
        :link =>   elem.get_my_link(),
        :title =>  elem.title,
        :number => elem.get_number(),
        :date =>   elem.get_date() 
      }; 

    end

    li.sort!{ |a,b| a[ :number ] <=> a[ :number ] };
    li.reverse!;
    return li;
  end 

  # TODO module
  def setup_view( title )
    @title = title;
  end 

end
