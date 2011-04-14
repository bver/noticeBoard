require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    super
     Privilege.delete_all
     @user = users(:one)
  end

  test "basic privileges" do
    Privilege.create :name => 'basic_right', :board => false

    assert_equal false, @user.privilege?(:basic_right)
    @user.grant(:basic_right)
    assert_equal true, @user.privilege?(:basic_right)
    assert_equal true, @user.privilege?('basic_right')
    @user.grant(:basic_right) # can be granted more times
    assert_equal true, @user.privilege?(:basic_right)
    @user.revoke(:basic_right)
    assert_equal false, @user.privilege?(:basic_right)
    @user.revoke(:basic_right) # can be revoked more times
    assert_equal false, @user.privilege?(:basic_right)
  end

  test "board privileges" do
    Privilege.create :name => 'board_right', :board => true

    assert_equal false, @user.privilege?(:board_right,42)
    assert_equal false, @user.privilege?('board_right',42)
    assert_equal false, @user.privilege?(:board_right,100)

    @user.grant(:board_right,42)
    assert_equal true, @user.privilege?(:board_right,42)
    assert_equal false, @user.privilege?(:board_right,100)

    @user.grant(:board_right,42) # can be granted more times
    assert_equal true, @user.privilege?(:board_right,42)
    assert_equal false, @user.privilege?(:board_right,100)

    @user.revoke(:board_right,42)
    assert_equal false, @user.privilege?(:board_right,42)
    assert_equal false, @user.privilege?(:board_right,100)

    @user.revoke(:board_right, 42) # can be revoked more times
    assert_equal false, @user.privilege?(:board_right,42)
    assert_equal false, @user.privilege?(:board_right,100)
  end

  test "cannot use undefined privilege" do
    assert_raise( ActiveRecord::RecordNotFound  ) { @user.privilege?(:unknown_right) }
    assert_raise( ActiveRecord::RecordNotFound  ) { @user.grant(:unknown_right) }
    assert_raise( ActiveRecord::RecordNotFound  ) { @user.revoke(:unknown_right) }
    assert_raise( ActiveRecord::RecordNotFound  ) { @user.privilege?(:unknown_right,44) }
    assert_raise( ActiveRecord::RecordNotFound  ) { @user.grant(:unknown_right,43) }
    assert_raise( ActiveRecord::RecordNotFound  ) { @user.revoke(:unknown_right,42) }
  end

  test "can mix basic rights with board ones" do
    Privilege.create :name => 'board_right', :board => true

    assert_equal false, @user.privilege?(:board_right,42)
    assert_equal false, @user.privilege?('board_right',42)
    assert_equal false, @user.privilege?(:board_right,4)
    assert_equal false, @user.privilege?('board_right',4)
    assert_equal false, @user.privilege?(:board_right)
    assert_equal false, @user.privilege?('board_right')

    @user.grant(:board_right,42)
    assert_equal true, @user.privilege?('board_right',42)
    assert_equal false, @user.privilege?('board_right',4)
    assert_equal false, @user.privilege?('board_right',2)
    assert_equal false, @user.privilege?('board_right')
    @user.grant('board_right',42)
    assert_equal true, @user.privilege?(:board_right,42)
    assert_equal false, @user.privilege?(:board_right,4)
    assert_equal false, @user.privilege?(:board_right,2)
    assert_equal false, @user.privilege?(:board_right)
    @user.grant(:board_right)
    assert_equal true, @user.privilege?(:board_right,42)
    assert_equal true, @user.privilege?(:board_right,4)
    assert_equal true, @user.privilege?(:board_right,2)
    assert_equal true, @user.privilege?(:board_right)
    @user.grant('board_right',4)
    assert_equal true, @user.privilege?(:board_right,42)
    assert_equal true, @user.privilege?(:board_right,4)
    assert_equal true, @user.privilege?(:board_right,2)
    assert_equal true, @user.privilege?(:board_right)
    @user.revoke(:board_right,42)
    assert_equal false, @user.privilege?(:board_right,42)
    assert_equal true, @user.privilege?(:board_right,4)
    assert_equal true, @user.privilege?(:board_right,2)
    assert_equal true, @user.privilege?(:board_right)
    @user.revoke(:board_right,2)
    assert_equal false, @user.privilege?(:board_right,42)
    assert_equal true, @user.privilege?(:board_right,4)
    assert_equal false, @user.privilege?(:board_right,2)
    assert_equal true, @user.privilege?(:board_right)
    @user.revoke('board_right')
    assert_equal false, @user.privilege?('board_right',42)
    assert_equal false, @user.privilege?('board_right',4)
    assert_equal false, @user.privilege?('board_right',2)
    assert_equal false, @user.privilege?('board_right')
    @user.grant('board_right',4)
    assert_equal false, @user.privilege?('board_right',42)
    assert_equal true, @user.privilege?('board_right',4)
    assert_equal false, @user.privilege?('board_right',2)
    assert_equal false, @user.privilege?('board_right')
  end

end
