
class PagesController < ApplicationController
  def gallery
  end

  def archives
    @comic_archives = query_comic_archives();
  end

  def misc
  end

  def about
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
  def query_comic_archives()
    # TODO use paging
    li = ComicStrip.find(:all).collect do |strip|
      { 
        :image =>  strip.get_thumbnail(),
        :link =>   strip.get_my_link(),
        :title =>  strip.title,
        :number => strip.get_number(),
        :date =>   strip.get_date() 
      } 
    end

    li.sort!{ |a,b| a[ :number ] <=> a[ :number ] };
    li.reverse!;
    return li;
  end
    

end
