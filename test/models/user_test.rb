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

  class PasswordValidationsTest < ActiveSupport::TestCase
    def setup
      @user = users(:one)
      @user.password = "Validp@ss123"
    end

    test "should not be too short" do
      @user.password = "Short1@"
      assert_not @user.valid?
      assert_includes @user.errors[:password], "must be between 10 and 16 characters"
    end

    test "should not be too long" do
      @user.password = "Toolongp@ssword123"
      assert_not @user.valid?
      assert_includes @user.errors[:password], "must be between 10 and 16 characters"
    end

    test "with valid length should be accepted" do
      @user.password = "Validp@ss123"
      assert @user.valid?
    end

    test "should contain at least one lowercase letter" do
      @user.password = "PASSWORD123@"
      assert_not @user.valid?
      assert_includes @user.errors[:password], "must contain at least one lowercase letter"
    end

    test "should contain at least one uppercase letter" do
      @user.password = "password123@"
      assert_not @user.valid?
      assert_includes @user.errors[:password], "must contain at least one uppercase letter"
    end

    test "should contain at least one digit" do
      @user.password = "Password@xxx"
      assert_not @user.valid?
      assert_includes @user.errors[:password], "must contain at least one digit"
    end


    test "should not contain three repeating characters" do
      @user.password = "PasssWord123"
      assert_not @user.valid?
      assert_includes @user.errors[:password], "cannot contain three repeating characters"
    end

    test "should collect all error messages" do
      @user.password = "aaa"
      assert_not @user.valid?
      assert_includes @user.errors[:password], "must be between 10 and 16 characters"
      assert_includes @user.errors[:password], "must contain at least one uppercase letter"
      assert_includes @user.errors[:password], "must contain at least one digit"
      assert_includes @user.errors[:password], "cannot contain three repeating characters"
    end
  end
end
