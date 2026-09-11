require "test_helper"

class CatalogTest < ActionDispatch::IntegrationTest
  test "home opens with newest published products and an archive selection" do
    get root_path
    assert_response :success
    assert_select "h1", /TIMES.*REMAKE/
    assert_select "a[href=?]", shop_path, text: /VIEW COLLECTION/
    assert_select "footer", /Unofficial educational concept project/
    assert_select "#new-arrivals article[data-product-slug]", count: 4
    assert_select "#new-arrivals article:first-child[data-product-slug=?]", products(:zero_stock).slug
    assert_select "#archive-selection article[data-product-slug=?]", products(:sold).slug
    assert_not_includes product_slugs, products(:draft).slug
    assert_select ".hero img[src*='times-remake-hero'][loading=eager][fetchpriority=high][srcset]"
    assert_select "#stories"
    assert_select "#concept"
    assert_select ".wall-writing[aria-hidden=true]", count: 2
  end

  test "catalog opens with all published products and a GET form" do
    get shop_path
    assert_response :success
    assert_equal 4, product_slugs.size
    assert_not_includes product_slugs, products(:draft).slug
    assert_select "form[method=get][action=?][data-turbo=false]", shop_path
    assert_select ".one-of-one", text: "ONE OF ONE"
    assert_select ".sold-stamp", text: "SOLD"
  end

  test "brand filter works" do
    get shop_path, params: { brand: brands(:archive_house).slug }
    assert_equal [ products(:sold).slug, products(:tee).slug ], product_slugs
    assert_select "select[name=brand] option[selected][value=?]", brands(:archive_house).slug
  end

  test "category filter works" do
    get shop_path, params: { category: categories(:jackets).slug }
    assert_equal [ products(:sold).slug, products(:jacket).slug ], product_slugs
  end

  test "direction filter works" do
    get shop_path, params: { direction: "remake" }
    assert_equal [ products(:jacket).slug ], product_slugs
  end

  test "available filter excludes sold and zero-stock products" do
    get shop_path, params: { available: "1" }
    assert_equal [ products(:tee).slug, products(:jacket).slug ], product_slugs
  end

  test "filters combine and stay selected" do
    get shop_path, params: { brand: brands(:studio).slug, category: "jackets", direction: "remake", available: "1", sort: "price_asc" }
    assert_equal [ products(:jacket).slug ], product_slugs
    assert_select "input[name=available][checked]"
    assert_select "select[name=sort] option[selected][value=price_asc]"
  end

  test "prices sort in both directions and newest is default" do
    get shop_path, params: { sort: "price_asc" }
    expected = [ products(:zero_stock).slug, products(:tee).slug, products(:jacket).slug, products(:sold).slug ]
    assert_equal expected, product_slugs
    get shop_path, params: { sort: "price_desc" }
    assert_equal expected.reverse, product_slugs
    get shop_path
    assert_equal [ products(:zero_stock).slug, products(:sold).slug, products(:tee).slug, products(:jacket).slug ], product_slugs
  end

  test "unknown sort falls back to newest instead of interpolating SQL" do
    get shop_path, params: { sort: "price_cents; DROP TABLE products" }
    assert_response :success
    assert_equal products(:zero_stock).slug, product_slugs.first
  end

  test "empty results provide a reset link" do
    get shop_path, params: { brand: brands(:studio).slug, direction: "archive" }
    assert_response :success
    assert_empty product_slugs
    assert_select ".empty-state h2", "No pieces found."
    assert_select ".empty-state a[href=?]", shop_path
  end

  test "unknown filter returns empty results" do
    get shop_path, params: { brand: "not-a-brand" }
    assert_response :success
    assert_empty product_slugs
  end

  test "product opens by slug with price and measurements" do
    get product_path(products(:jacket))
    assert_response :success
    assert_select "h1", products(:jacket).name
    assert_select ".detail-price", /¥1,200.50/
    assert_select "dd", "58 cm"
    assert_select "dd", "8.5 / 10"
    assert_select ".badge", "ONE OF ONE"
    assert_select "button[disabled]"
    assert_select "#cart-notice", "Cart will be added in the next development stage"
    assert_select "img[src*='product-placeholder']"
  end

  test "sold product is displayed as unavailable" do
    get product_path(products(:sold))
    assert_response :success
    assert_select ".sold-notice", "SOLD — MOVED TO ARCHIVE"
    assert_select ".badge", "SOLD"
    assert_select "button:not([disabled])", count: 0
  end

  test "zero-stock product and absent optional details render correctly" do
    get product_path(products(:zero_stock))
    assert_response :success
    assert_select ".badge", "UNAVAILABLE"
    assert_select "button[disabled]", "CURRENTLY UNAVAILABLE"
    assert_select "p", "Measurements have not been recorded."
  end

  test "missing slug and draft return 404" do
    get product_path("not-found")
    assert_response :not_found
    get product_path(products(:draft))
    assert_response :not_found
  end

  private

  def product_slugs
    css_select("article[data-product-slug]").map { |card| card["data-product-slug"] }
  end
end
