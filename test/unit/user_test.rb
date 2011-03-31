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

  test "cannot mix basic rights with board ones" do
    Privilege.create :name => 'basic_right', :board => false
    Privilege.create :name => 'board_right', :board => true

    assert_raise( ActiveRecord::RecordNotFound  ) { @user.privilege?(:board_right) }
    assert_raise( ActiveRecord::RecordNotFound  ) { @user.grant(:board_right) }
    assert_raise( ActiveRecord::RecordNotFound  ) { @user.revoke(:board_right) }
    assert_raise( ActiveRecord::RecordNotFound  ) { @user.privilege?(:basic_right,44) }
    assert_raise( ActiveRecord::RecordNotFound  ) { @user.grant(:basic_right,43) }
    assert_raise( ActiveRecord::RecordNotFound  ) { @user.revoke(:basic_right,42) }    
  end

#  test "list privileges" do
#    Privilege.delete_all
#    Privilege.create :name => 'first_right', :description => 'descr.1', :board => false
#    Privilege.create :name => 'second_right', :description => 'descr.2', :board => false
#    Privilege.create :name => 'third_right', :description => 'descr.3', :board => true
#    u = users(:one)
#
#    list = u.list_privileges
#    assert_equal 3, list.size
#    assert list.include?( { :name => 'first_right', :description => 'descr.1', :board => nil, :granted => false } )
#    assert list.include?( { :name => 'second_right', :description => 'descr.2', :board => nil, :granted => false } )
#    assert list.include?( { :name => 'third_right', :description => 'descr.3', :board => nil, :granted => false } )
#
#    u.grant(:third_right,15)
#    u.grant(:first_right)
#    u.grant(:third_right,25)
#
#    list = u.list_privileges
#    assert_equal 4, list.size
#    assert list.include?( { :name => 'first_right', :description => 'descr.1', :board => nil, :granted => true } )
#    assert list.include?( { :name => 'second_right', :description => 'descr.2', :board => nil, :granted => false } )
#    assert list.include?( { :name => 'third_right', :description => 'descr.3', :board => 15, :granted => true } )
#    assert list.include?( { :name => 'third_right', :description => 'descr.3', :board => 25, :granted => true } )
#  end

end
