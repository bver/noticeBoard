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
    assert_equal :raise_priority, c.sense
    c.meaning = 8
    assert_equal :lower_priority, c.sense
    c.meaning = 9
    assert_equal :start_work, c.sense
    c.meaning = 10
    assert_equal :stop_work, c.sense
    c.meaning = 11
    assert_equal :set_problem, c.sense
    c.meaning = 12
    assert_equal :reset_problem, c.sense
    c.meaning = 13
    assert_equal :unassigned, c.sense
    c.meaning = 14
    assert_equal :edited_title, c.sense
    c.meaning = 15
    assert_equal :edited_content, c.sense
    c.meaning = 16
    assert_equal :attachement, c.sense
    c.meaning = 17
    assert_equal :set_date, c.sense
    c.meaning = 18
    assert_equal :set_time, c.sense
    c.meaning = 19
    assert_equal :reset_date, c.sense
    c.meaning = 20
    assert_equal :reset_time, c.sense
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
    c.sense = :raise_priority
    assert_equal 7, c.meaning
    c.sense = :lower_priority
    assert_equal 8, c.meaning
    c.sense = :start_work
    assert_equal 9, c.meaning
    c.sense = :stop_work
    assert_equal 10, c.meaning
    c.sense = :set_problem
    assert_equal 11, c.meaning
    c.sense = :reset_problem
    assert_equal 12, c.meaning
    c.sense = :unassigned
    assert_equal 13, c.meaning
    c.sense = :edited_title
    assert_equal 14, c.meaning
    c.sense = :edited_content
    assert_equal 15, c.meaning
    c.sense = :attachement
    assert_equal 16, c.meaning
    c.sense = :set_date
    assert_equal 17, c.meaning
    c.sense = :set_time
    assert_equal 18, c.meaning
    c.sense = :reset_date
    assert_equal 19, c.meaning
    c.sense = :reset_time
    assert_equal 20, c.meaning
  end
end
