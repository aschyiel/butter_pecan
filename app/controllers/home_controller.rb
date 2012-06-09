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
  end

  #
  # show the latest/most-recent comic strip,
  # this gets called by the client via ajax.
  #
  def show_latest
    @comicStrip = ComicStrip.find(:last); 
    logger.debug "loading comicStrip: #{@comicStrip}";
#   respond_with( @comicStrip.to_json() );
    respond_with( @comicStrip.content.to_json() );
  end

end
