require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should be valid" do
    user = users(:one)
    assert user.valid?
  end

  test "name should be present" do
    user = users(:one)
    user.name = "     "
    assert_not user.valid?
  end
end
