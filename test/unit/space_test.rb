require "test_helper"

class SpaceTest < ActiveSupport::TestCase
  test "requires a unique name" do
    duplicate = Space.new(name: spaces(:nyc_studio).name, city: cities(:new_york))

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end

  test "compiled address preserves the legacy display order" do
    space = spaces(:nyc_studio)

    assert_equal "123 Broadway   New York  NY 10001", space.compiled_address
  end

  test "primary image uses sort order" do
    space = spaces(:nyc_studio)
    later = space.space_images.create!(sort_order: 2) do |image|
      image.image.attach(
        io: StringIO.new("image"),
        filename: "later.png",
        content_type: "image/png"
      )
    end
    first = space.space_images.create!(sort_order: 0) do |image|
      image.image.attach(
        io: StringIO.new("image"),
        filename: "first.png",
        content_type: "image/png"
      )
    end

    assert_equal first, space.primary_image
    assert_not_equal later, space.primary_image
  end
end
