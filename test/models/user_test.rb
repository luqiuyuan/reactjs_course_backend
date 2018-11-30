require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(email: "test@bigfish.com", password: "123456aA", name: "Mr. Somebody", avatar_url: "http://www.baidu.com", description: "Call me maybe")
  end

  test "valid model should ba valid" do
    assert @user.valid?
  end

  test "model without email should not be valid" do
    @user.email = nil
    assert_not @user.valid?
  end

  test "model with email that is too long should not be valid" do
    @user.email = "a" * (User::EMAIL_LENGTH_MAX - 3) + "@a.a"
    assert_not @user.valid?
  end

  test "model with illegal email format should not be valid" do
    @user.email = "a@a@a.a"
    assert_not @user.valid?
  end

  test "model without password should not be valid" do
    @user.password = nil
    assert_not @user.valid?
  end

  test "model with password that is too short should not be valid" do
    @user.password = "a" * (User::PASSWORD_LENGTH_MIN - 1)
    assert_not @user.valid?
  end

  test "model with password that is too long should not be valid" do
    @user.password = "a" * (User::PASSWORD_LENGTH_MAX + 1)
    assert_not @user.valid?
  end

  test "model with password that does not contain downcase letters should not be valid" do
    @user.password = "ABCDEF"
    assert_not @user.valid?
  end

  test "model with password that does not contain upcase letters should not be valid" do
    @user.password = "abcdef"
    assert_not @user.valid?
  end

  test "model without name should be valid" do
    @user.name = nil
    assert @user.valid?
  end

  test "model with name that is too long should not be valid" do
    @user.name = "a" * (User::NAME_LENGTH_MAX + 1)
    assert_not @user.valid?
  end

  test "model without password should be valid on update" do
    user = users(:guojing)
    assert user.valid?
  end

  test "valid model should be valid on update" do
    user = users(:guojing)
    user.password = "123456aA"
    assert user.valid?
  end

  test "model with password that is too short should not be valid on update" do
    user = users(:guojing)
    user.password = "a" * (User::PASSWORD_LENGTH_MIN - 1)
    assert_not user.valid?
  end

  test "model without avatar_url should be valid" do
    @user.avatar_url = nil
    assert @user.valid?
  end

  test "model with avatar_url that is too long should not be valid" do
    @user.avatar_url = "a" * (User::AVATAR_URL_LENGTH_MAX + 1)
    assert_not @user.valid?
  end

  test "model without description should be valid" do
    @user.description = nil
    assert @user.valid?
  end

  test "model with description that is too long should not be valid" do
    @user.description = "a" * (User::DESCRIPTION_LENGTH_MAX + 1)
    assert_not @user.valid?
  end

end
