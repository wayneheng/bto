require 'test_helper'

class TownProjectsControllerTest < ActionController::TestCase
  setup do
    @town_project = town_projects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:town_projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create town_project" do
    assert_difference('TownProject.count') do
      post :create, town_project: { town_name: @town_project.town_name }
    end

    assert_redirected_to town_project_path(assigns(:town_project))
  end

  test "should show town_project" do
    get :show, id: @town_project
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @town_project
    assert_response :success
  end

  test "should update town_project" do
    patch :update, id: @town_project, town_project: { town_name: @town_project.town_name }
    assert_redirected_to town_project_path(assigns(:town_project))
  end

  test "should destroy town_project" do
    assert_difference('TownProject.count', -1) do
      delete :destroy, id: @town_project
    end

    assert_redirected_to town_projects_path
  end
end
