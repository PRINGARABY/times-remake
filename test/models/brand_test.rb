require "test_helper"

class BrandTest < ActiveSupport::TestCase
  test "name and unique URL-safe slug are required" do
    assert_not Brand.new.valid?
    assert_not Brand.new(name: "Another", slug: brands(:studio).slug).valid?
    assert_not Brand.new(name: "Another", slug: "Bad slug").valid?
  end

  test "brand with products cannot be deleted" do
    assert_not brands(:studio).destroy
    assert brands(:studio).errors[:base].any?
  end
end
