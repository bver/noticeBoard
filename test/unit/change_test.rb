require 'test_helper'

class ChangeTest < ActiveSupport::TestCase
  
  test "sense helper fw" do
    c = changes(:one)
    c.meaning = nil
    assert_equal nil, c.sense
    c.meaning = 0
    assert_equal :created, c.sense
    c.meaning = 1
    assert_equal :finished, c.sense
    c.meaning = 2
    assert_equal :cancelled, c.sense
    c.meaning = 3
    assert_equal :accepted, c.sense
    c.meaning = 4
    assert_equal :rejected, c.sense
    c.meaning = 5
    assert_equal :assigned, c.sense
    c.meaning = 6
    assert_equal :commented, c.sense
    c.meaning = 7
    assert_equal :set_priority, c.sense
    c.meaning = 8
    assert_equal :set_status, c.sense
  end

  test "sense helper bw" do
    c = changes(:one)
    c.sense = nil
    assert_equal nil, c.meaning
    c.sense = :created
    assert_equal 0, c.meaning
    c.sense = :finished
    assert_equal 1, c.meaning
    c.sense = :cancelled
    assert_equal 2, c.meaning
    c.sense = :accepted
    assert_equal 3, c.meaning
    c.sense = :rejected
    assert_equal 4, c.meaning
    c.sense = :assigned
    assert_equal 5, c.meaning
    c.sense = :commented
    assert_equal 6, c.meaning
    c.sense = :set_priority
    assert_equal 7, c.meaning
    c.sense = :set_status
    assert_equal 8, c.meaning
  end
end
