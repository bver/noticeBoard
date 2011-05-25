require 'test_helper'

class PermissionTest < ActiveSupport::TestCase
  test "basic test" do

    perm = Permission.new
    perm.grant(:edit_notes)
    assert_equal true, perm.privilege?(:edit_notes)
    assert_equal false, perm.privilege?(:assign_notes)
    perm.grant(:assign_notes)
    assert_equal true, perm.privilege?(:edit_notes)
    assert_equal true, perm.privilege?(:assign_notes)
    perm.revoke(:edit_notes)
    assert_equal false, perm.privilege?(:edit_notes)
    assert_equal true, perm.privilege?(:assign_notes)
    perm.revoke(:edit_notes)
    perm.grant(:assign_notes)
    assert_equal false, perm.privilege?(:edit_notes)
    assert_equal true, perm.privilege?(:assign_notes)

    assert_raise( ArgumentError  ) { perm.privilege?(:unknown1) }
    assert_raise( ArgumentError  ) { perm.grant(:unknown2) }
    assert_raise( ArgumentError  ) { perm.revoke(:unknown3) }
  end

  test "serialize" do
    perm1 = Permission.new( :user_id => 42 )
    perm1.grant(:edit_notes)
    assert_equal true, perm1.save

    perm = Permission.find_by_user_id 42
    assert_equal true, perm.privilege?(:edit_notes)
    assert_equal false, perm.privilege?(:assign_notes)
  end

  test "utils" do
    assert_equal :desc_edit_notes, Permission.description( :edit_notes )
    
    assert_equal [ :manage_users,  :add_boards,  :manage_boards,  :urgent_prio ], Permission.privs_user
    assert_equal [ :view_board, :edit_notes, :cancel_notes,  :assign_notes, :change_prio, :process_notes ], Permission.privs_board
    assert_equal Permission.privs_user+Permission.privs_board, Permission.privs
  end

end
