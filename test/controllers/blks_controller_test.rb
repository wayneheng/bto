require 'test_helper'

class BlksControllerTest < ActionController::TestCase
  setup do
    @blk = blks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:blks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create blk" do
    assert_difference('Blk.count') do
      post :create, blk: { contract: @blk.contract, neighbourhood: @blk.neighbourhood, project_id: @blk.project_id, title: @blk.title, url: @blk.url }
    end

    assert_redirected_to blk_path(assigns(:blk))
  end

  test "should show blk" do
    get :show, id: @blk
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @blk
    assert_response :success
  end

  test "should update blk" do
    patch :update, id: @blk, blk: { contract: @blk.contract, neighbourhood: @blk.neighbourhood, project_id: @blk.project_id, title: @blk.title, url: @blk.url }
    assert_redirected_to blk_path(assigns(:blk))
  end

  test "should destroy blk" do
    assert_difference('Blk.count', -1) do
      delete :destroy, id: @blk
    end

    assert_redirected_to blks_path
  end
end
