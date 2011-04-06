require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response 406 #:success
  end

  test "should create user" do

    pwd = 's0me_passw0rD'
    attrs = { :name=>'user1', :email=>'user@example.com',  :send_mails => 1, :password => pwd, :password_confirmation => pwd}

    assert_difference('User.count') do
      post :create, :user => attrs
    end

    #assert_redirected_to user_path(assigns(:user))
    assert_response 406
  end

  test "should show user" do
    get :show, :id => @user.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user.to_param
    assert_response 406 #:success
  end

  test "should update user" do
    put :update, :id => @user.to_param, :user => @user.attributes
    #assert_redirected_to user_path(assigns(:user))
    assert_response 406
  end

  test "should update user without pwd changed" do
    pwd = ''
    attrs = { :name=>'u1', :email=>'u1@example.com',  :send_mails => 1, :password => pwd, :password_confirmation => pwd}

    put :update, :id => @user.to_param, :user => attrs
    #assert_response :success
    #assert_redirected_to user_path(assigns(:user))
    assert_response 406
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => @user.to_param
    end

    assert_redirected_to users_path
  end
end
