require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "name and unique URL-safe slug are required" do
    assert_not Category.new.valid?
    assert_not Category.new(name: "Another", slug: categories(:tees).slug).valid?
    assert_not Category.new(name: "Another", slug: "Bad slug").valid?
  end

  test "category with products cannot be deleted" do
    assert_not categories(:tees).destroy
    assert categories(:tees).errors[:base].any?
  end
end
