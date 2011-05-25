require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    super
     @user = users(:one)
     Permission.destroy_all # (  @user.permissions.map {|p| p.id} )
     @user.ensure_permissions
     @user.ensure_permissions(42)
     @user.ensure_permissions(4)
     @user.ensure_permissions(2)
  end

  test "new user defaults" do
    u = User.new
    Permission.privs.each do |p|
      case p
      when :view_board, :process_notes
        assert_equal true, u.privilege?(p)
      else
        assert_equal false, u.privilege?(p)
      end
    end
  end

  test "copy board defaults" do
    @user.grant(:assign_notes)
    assert_equal true, @user.privilege?(:assign_notes)

    @user.ensure_permissions 200
    assert_equal true, @user.privilege?(:assign_notes, 200)

    @user.revoke(:assign_notes)
    assert_equal true, @user.privilege?(:assign_notes, 200)
    assert_equal false, @user.privilege?(:assign_notes)
  end

  test "basic privileges" do
    assert_equal false, @user.privilege?(:assign_notes)
    @user.grant(:assign_notes)
    assert_equal true, @user.privilege?(:assign_notes)
    @user.grant(:assign_notes) # can be granted more times
    assert_equal true, @user.privilege?(:assign_notes)
    @user.revoke(:assign_notes)
    assert_equal false, @user.privilege?(:assign_notes)
    @user.revoke(:assign_notes) # can be revoked more times
    assert_equal false, @user.privilege?(:assign_notes)
  end

  test "board privileges" do
    assert_equal false, @user.privilege?(:view_board,42)
    assert_equal false, @user.privilege?(:view_board,2)

    @user.grant(:view_board,42)
    assert_equal true, @user.privilege?(:view_board,42)
    assert_equal false, @user.privilege?(:view_board,2)
    assert_equal false, @user.privilege?(:view_board)

    @user.grant(:view_board,42) # can be granted more times
    assert_equal true, @user.privilege?(:view_board,42)
    assert_equal false, @user.privilege?(:view_board,2)

    @user.revoke(:view_board,42)
    assert_equal false, @user.privilege?(:view_board,42)
    assert_equal false, @user.privilege?(:view_board,2)

    @user.revoke(:view_board, 42) # can be revoked more times
    assert_equal false, @user.privilege?(:view_board,42)
    assert_equal false, @user.privilege?(:view_board,2)
  end

  test "cannot use undefined privilege" do
    assert_raise( ArgumentError  ) { @user.privilege?(:unknown_right) }
    assert_raise( ArgumentError  ) { @user.grant(:unknown_right) }
    assert_raise( ArgumentError  ) { @user.revoke(:unknown_right) }
    assert_raise( ArgumentError  ) { @user.privilege?(:unknown_right,4) }
    assert_raise( ArgumentError  ) { @user.grant(:unknown_right,4) }
    assert_raise( ArgumentError  ) { @user.revoke(:unknown_right,4) }
  end

  test "can mix basic rights with board ones" do
    assert_equal false, @user.privilege?(:view_board,42)
    assert_equal false, @user.privilege?(:view_board,4)
    assert_equal false, @user.privilege?(:view_board)

    @user.grant(:view_board,42)
    assert_equal true, @user.privilege?(:view_board,42)
    assert_equal false, @user.privilege?(:view_board,4)
    assert_equal false, @user.privilege?(:view_board,2)
    assert_equal false, @user.privilege?(:view_board)
    @user.grant(:view_board)
    assert_equal true, @user.privilege?(:view_board,42)
    assert_equal false, @user.privilege?(:view_board,4)
    assert_equal false, @user.privilege?(:view_board,2)
    assert_equal true, @user.privilege?(:view_board)
    @user.grant(:view_board,4)
    assert_equal true, @user.privilege?(:view_board,42)
    assert_equal true, @user.privilege?(:view_board,4)
    assert_equal false, @user.privilege?(:view_board,2)
    assert_equal true, @user.privilege?(:view_board)
    @user.revoke(:view_board,42)
    assert_equal false, @user.privilege?(:view_board,42)
    assert_equal true, @user.privilege?(:view_board,4)
    assert_equal false, @user.privilege?(:view_board,2)
    assert_equal true, @user.privilege?(:view_board)
    @user.revoke(:view_board,2)
    assert_equal false, @user.privilege?(:view_board,42)
    assert_equal true, @user.privilege?(:view_board,4)
    assert_equal false, @user.privilege?(:view_board,2)
    assert_equal true, @user.privilege?(:view_board)
    @user.revoke(:view_board)
    assert_equal false, @user.privilege?(:view_board,42)
    assert_equal true, @user.privilege?(:view_board,4)
    assert_equal false, @user.privilege?(:view_board,2)
    assert_equal false, @user.privilege?(:view_board)
    @user.grant(:view_board,4)
    assert_equal false, @user.privilege?(:view_board,42)
    assert_equal true, @user.privilege?(:view_board,4)
    assert_equal false, @user.privilege?(:view_board,2)
    assert_equal false, @user.privilege?(:view_board)
  end

end
