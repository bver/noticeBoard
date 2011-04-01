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
end
