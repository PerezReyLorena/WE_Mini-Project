require 'test_helper'

class PartnershipsControllerTest < ActionController::TestCase
  setup do
    @partnership = partnerships(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:partnerships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create partnership" do
    assert_difference('Partnership.count') do
      post :create, partnership: { game_id: @partnership.game_id, user1_id: @partnership.user1_id, user2_id: @partnership.user2_id }
    end

    assert_redirected_to partnership_path(assigns(:partnership))
  end

  test "should show partnership" do
    get :show, id: @partnership
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @partnership
    assert_response :success
  end

  test "should update partnership" do
    patch :update, id: @partnership, partnership: { game_id: @partnership.game_id, user1_id: @partnership.user1_id, user2_id: @partnership.user2_id }
    assert_redirected_to partnership_path(assigns(:partnership))
  end

  test "should destroy partnership" do
    assert_difference('Partnership.count', -1) do
      delete :destroy, id: @partnership
    end

    assert_redirected_to partnerships_path
  end
end
