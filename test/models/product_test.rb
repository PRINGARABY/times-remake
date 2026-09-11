require "test_helper"

class ProductTest < ActiveSupport::TestCase
  setup do
    @product = products(:jacket)
  end

  test "fixture is valid and belongs to its brand and category" do
    assert @product.valid?
    assert_equal brands(:studio), @product.brand
    assert_equal categories(:jackets), @product.category
    assert_includes brands(:studio).products, @product
    assert_includes categories(:jackets).products, @product
  end

  test "required fields and associations cannot be blank" do
    %i[name slug description direction price_cents currency quantity status brand category].each do |field|
      product = @product.dup
      product.slug = "unique-test-piece" unless field == :slug
      product.public_send("#{field}=", nil)
      assert_not product.valid?, "#{field} should be required"
      assert product.errors[field].any?, "Expected an error for #{field}"
    end
  end

  test "price and quantity must be non-negative integers" do
    %i[price_cents quantity].each do |field|
      [ -1, 1.5 ].each do |value|
        @product.public_send("#{field}=", value)
        assert_not @product.valid?
        assert @product.errors[field].any?
      end
      @product.public_send("#{field}=", 0)
      assert @product.valid?
    end
  end

  test "condition score accepts boundaries and rejects values outside one through ten" do
    [ 0.9, 10.1 ].each do |score|
      @product.condition_score = score
      assert_not @product.valid?
    end
    [ 1, 10, nil ].each do |score|
      @product.condition_score = score
      assert @product.valid?
    end
  end

  test "slug is unique and URL safe" do
    duplicate = @product.dup
    assert_not duplicate.valid?
    assert duplicate.errors[:slug].any?
    @product.slug = "Not a slug!"
    assert_not @product.valid?
  end

  test "one of one means exactly one unit" do
    assert @product.one_of_one?
    assert_not products(:tee).one_of_one?
    assert_not products(:zero_stock).one_of_one?
  end

  test "sold status always makes a product unavailable even with a positive quantity" do
    @product.status = "sold"
    assert @product.sold?
    assert_not @product.in_stock?
    assert_equal "SOLD", @product.availability_label
    assert @product.one_of_one?
  end

  test "draft and zero-stock products are unavailable" do
    assert_not products(:draft).in_stock?
    assert_not products(:zero_stock).in_stock?
    assert @product.in_stock?
  end

  test "direction status currency and measurements reject unsupported values" do
    @product.assign_attributes(direction: "unknown", status: "reserved", currency: "USD", measurements: [])
    assert_not @product.valid?
    %i[direction status currency measurements].each { |field| assert @product.errors[field].any? }
  end

  test "product supports multiple Active Storage images" do
    assert_equal :has_many_attached, Product.reflect_on_attachment(:images).macro
    assert_equal @product.slug, @product.to_param
    assert_match(/\ATR-\d+\z/, @product.archive_code)
  end

  test "database rejects negative prices without model validations" do
    assert_raises ActiveRecord::StatementInvalid do
      Product.transaction(requires_new: true) { @product.update_columns(price_cents: -1) }
    end
  end
end
