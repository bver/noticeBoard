require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "state helper" do
    one =notes(:one)
    assert one.outcome.nil?
    assert_equal :active, one.status

    two =notes(:done)
    assert_equal true, two.outcome
    assert_equal :finished, two.status

    three =notes(:failed)
    assert_equal false, three.outcome
    assert_equal :cancelled, three.status
  end

  test "status2outcome helper" do
    assert_equal nil, Note.status2outcome( :active )
    assert_equal true, Note.status2outcome( :finished )
    assert_equal false, Note.status2outcome( :cancelled )
    assert_raise( ArgumentError ) { Note.status2outcome( :unknown ) }
  end

  test "status2outcome textual helper" do
    assert_equal nil, Note.status2outcome( 'A' )
    assert_equal true, Note.status2outcome( 'finished' )
    assert_equal false, Note.status2outcome( 'c' )
    assert_raise( ArgumentError ) { Note.status2outcome( 'unk' ) }
  end

  test "status assign" do
    one =notes(:one)

    one.status = :active
    assert_equal nil, one.outcome
    one.status = :finished
    assert_equal true, one.outcome
    one.status = :cancelled
    assert_equal false, one.outcome

    assert_raise( ArgumentError ) { one.status = :unknown }
  end

  test "instant datetime" do
    one =notes(:one)
    assert_nil one.date
    assert_nil one.time

    one.time = '13:30'
    assert_equal '13:30', one.time
    assert_nil one.date

   one.date = '22.4.1970'
    assert_equal '13:30', one.time
   assert_equal '22.04.1970', one.date

    one.time = nil
    assert_equal '22.04.1970', one.date
    assert_nil one.time

    one.date = nil
    assert_nil one.date
    assert_nil one.time
  end


end
