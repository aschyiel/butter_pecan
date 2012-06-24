require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get gallery" do
    get :gallery
    assert_response :success
  end

  test "should get archives" do
    get :archives
    assert_response :success
  end

  test "should get misc" do
    get :misc
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

end
