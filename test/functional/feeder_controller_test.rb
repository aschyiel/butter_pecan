require 'test_helper'
require 'rexml/document'

class FeederControllerTest < ActionController::TestCase

  fixtures :comic_strips
# self.use_instantiated_fixtures = :no_instances;
  self.use_instantiated_fixtures = true;

  test "should get rss" do
    get :rss
    assert_response :success
  end

  test "get_rss_xml should return actually readable xml"  do
    debug "get_rss_xml should return actually readable xml"
    puts "TEST!!!"
    strips = [];
    strips << comic_strips(:one);  
    strips << comic_strips(:two);  
    strips << comic_strips(:three);  # TODO how to get all fixtures into a list all at once?
    debug "strips - #{ strips }"

    xml = @controller.get_rss_xml( strips );
    debug "xml - #{ xml }"
    assert xml;

    doc = REXML::Document.new( xml );
    assert doc;

  end

  # note:debug output can be found under log/test.log.
  def debug( msg )
    Rails::logger.debug msg
    #puts "DEBUG::#{msg}"
  end

end
