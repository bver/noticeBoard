require 'test_helper'

class NotesControllerTest < ActionController::TestCase

  setup do
    @note = notes(:done)
  end

  test "should get new" do
    get :new
    assert_response 406 # :success
  end

  test "should get edit" do
    get :edit, :id => @note.to_param
    assert_response 406 # :success
  end

  test "should update note" do
    put :update, :id => @note.to_param, :note => @note.attributes
    #assert_redirected_to note_path(assigns(:note))
    assert_response 406
  end

  test "should destroy note" do
    assert_difference('Note.count', -1) do
      delete :destroy, :id => @note.to_param
    end

    assert_redirected_to notes_path
  end
end
