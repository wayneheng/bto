require 'test_helper'

class LaunchesControllerTest < ActionController::TestCase
  setup do
    @launch = launches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:launches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create launch" do
    assert_difference('Launch.count') do
      post :create, launch: { imagePath: @launch.imagePath, title: @launch.title, version: @launch.version }
    end

    assert_redirected_to launch_path(assigns(:launch))
  end

  test "should show launch" do
    get :show, id: @launch
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @launch
    assert_response :success
  end

  test "should update launch" do
    patch :update, id: @launch, launch: { imagePath: @launch.imagePath, title: @launch.title, version: @launch.version }
    assert_redirected_to launch_path(assigns(:launch))
  end

  test "should destroy launch" do
    assert_difference('Launch.count', -1) do
      delete :destroy, id: @launch
    end

    assert_redirected_to launches_path
  end
end
