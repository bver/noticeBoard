require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "basic privileges" do
    u = users(:one)
    p = Privilege.create :name => 'basic_right', :board => false

    assert_equal false, u.privilege?(:basic_right)
    u.grant(:basic_right)
    assert_equal true, u.privilege?(:basic_right)
    u.grant(:basic_right) # can be granted more times
    assert_equal true, u.privilege?(:basic_right)
    u.revoke(:basic_right)
    assert_equal false, u.privilege?(:basic_right)
    u.revoke(:basic_right) # can be revoked more times
    assert_equal false, u.privilege?(:basic_right)
  end
  
  test "cannot use undefined privilege" do
    u = users(:one)
    assert_raise( ActiveRecord::RecordNotFound  ) { u.privilege?(:unknown_right) }
    assert_raise( ActiveRecord::RecordNotFound  ) { u.grant(:unknown_right) }
    assert_raise( ActiveRecord::RecordNotFound  ) { u.revoke(:unknown_right) }
  end

  test "list privileges" do
    Privilege.delete_all
    Privilege.create :name => 'first_right', :description => 'descr.1', :board => false
    Privilege.create :name => 'second_right', :description => 'descr.2', :board => false
    Privilege.create :name => 'third_right', :description => 'descr.3', :board => false
    u = users(:one)

    list = u.list_privileges
    assert_equal 3, list.size
    assert list.include?( { :name => 'first_right', :description => 'descr.1', :board => nil, :granted => false } )
    assert list.include?( { :name => 'second_right', :description => 'descr.2', :board => nil, :granted => false } )
    assert list.include?( { :name => 'third_right', :description => 'descr.3', :board => nil, :granted => false } )

    u.grant(:third_right)
    u.grant(:first_right)

    list = u.list_privileges
    assert_equal 3, list.size
    assert list.include?( { :name => 'first_right', :description => 'descr.1', :board => nil, :granted => true } )
    assert list.include?( { :name => 'second_right', :description => 'descr.2', :board => nil, :granted => false } )
    assert list.include?( { :name => 'third_right', :description => 'descr.3', :board => nil, :granted => true } )
  end

end
