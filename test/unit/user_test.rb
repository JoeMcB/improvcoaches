require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "requires a name valid unique email and password" do
    user = User.new(name: "", email: "bad", password: "")

    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
    assert_includes user.errors[:email], "is not a valid email."
    assert user.errors[:password].present?

    duplicate = User.new(name: "Duplicate", email: users(:member).email.upcase, password: "secret")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email], "has already been taken"
  end

  test "creation normalizes email and supplies domain defaults" do
    user = User.create!(
      name: "Fresh User",
      email: "FRESH@EXAMPLE.COM",
      password: "secret",
      is_improv: false
    )

    assert_equal "fresh@example.com", user.email
    assert_equal "", user.bio
    assert_not user.is_coach?
    assert user.is_active?
    assert_not user.is_improv?
    assert_not user.is_sketch?
    assert_equal(-1, user.rating)
    assert user.auth_token.present?
    assert_predicate user.schedule, :persisted?
  end

  test "coach scopes require a coaching discipline" do
    assert_includes User.coaches, users(:coach)
    assert_includes User.coaches, users(:admin)
    assert_not_includes User.coaches, users(:member)
  end

  test "rating calculation handles no votes and percentages" do
    user = users(:coach)

    user.define_singleton_method(:liked_by_count) { 0 }
    user.define_singleton_method(:disliked_by_count) { 0 }
    assert_equal(-1, user.calculate_rating)

    user.define_singleton_method(:liked_by_count) { 3 }
    user.define_singleton_method(:disliked_by_count) { 1 }
    assert_equal 75.0, user.calculate_rating
  end

  test "experience lookup matches both theatre and experience type" do
    assert users(:coach).has_experience?(theatres(:ucb).id, experience_types(:teacher).id)
    assert_not users(:coach).has_experience?(theatres(:ucb).id, experience_types(:student).id)
  end

  test "unlink removes oauth credentials" do
    user = users(:member)
    user.update!(provider: "facebook", uid: "123", oauth_token: "token", oauth_token_expires_at: 1.day.from_now)

    user.unlink!

    assert_nil user.provider
    assert_nil user.uid
    assert_nil user.oauth_token
    assert_nil user.oauth_token_expires_at
  end
end
