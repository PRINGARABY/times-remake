require "application_system_test_case"

class ArchiveTest < ApplicationSystemTestCase
  test "visitor enters the archive filters it and opens a piece" do
    visit root_path
    click_on "VIEW COLLECTION"
    select "Demo Studio", from: "Brand"
    select "Jackets", from: "Category"
    select "Remake", from: "Direction"
    check "Available only"
    click_on "Apply filters"
    assert_selector "article[data-product-slug]", count: 1
    click_on products(:jacket).name
    assert_selector "h1", text: products(:jacket).name
    assert_text "ONE OF ONE"
    assert_selector "button[disabled]"
    assert_text "Cart will be added in the next development stage"
  end

  test "sold archive pieces cannot be purchased" do
    visit product_path(products(:sold))
    assert_text "SOLD — MOVED TO ARCHIVE"
    assert_no_selector ".detail-copy button:not([disabled])"
  end

  test "empty filter results can be cleared" do
    visit shop_path
    select "Demo Studio", from: "Brand"
    select "Archive", from: "Direction"
    click_on "Apply filters"
    assert_text "No pieces found."
    click_on "Clear filters"
    assert_selector "article[data-product-slug]", count: 4
  end

  test "search narrows the current collection and can be cleared" do
    visit shop_path
    fill_in "SEARCH THESE PIECES", with: "reworked jacket"
    assert_selector "article[data-product-slug]", count: 1
    assert_text "1 of 4 pieces"
    fill_in "SEARCH THESE PIECES", with: "no matching garment"
    assert_text "No pieces match your search."
    assert_no_selector "article[data-product-slug]"
    click_on "Clear search"
    assert_selector "article[data-product-slug]", count: 4
    assert_equal "piece-search", page.evaluate_script("document.activeElement.id")
  end

  test "mobile menu supports keyboard closing navigation and honest cart notice" do
    set_viewport(390, 844)
    visit root_path
    menu = find(".mobile-navigation summary")
    menu.send_keys(:enter)
    assert_selector ".mobile-navigation[open]"
    page.send_keys(:escape)
    assert_no_selector ".mobile-navigation[open]"
    assert_equal "Menu", page.evaluate_script("document.activeElement.getAttribute('aria-label')")
    menu.click
    within("nav[aria-label='Mobile navigation']") { click_on "SHOP" }
    assert_current_path shop_path
    assert_no_selector ".mobile-navigation[open]"
    find(".cart-disclosure summary").click
    assert_text "Cart will be added in the next development stage"
    page.send_keys(:escape)
    assert_no_selector ".cart-disclosure[open]"
  ensure
    clear_viewport
  end

  test "pages fit desktop tablet and mobile with a sticky header and transparent cards" do
    [ [ 1440, 900 ], [ 768, 1024 ], [ 390, 844 ] ].each do |width, height|
      set_viewport(width, height)
      [ root_path, shop_path, product_path(products(:jacket)) ].each_with_index do |path, index|
        visit path
        assert_selector "h1", visible: :all
        assert_equal width, page.evaluate_script("window.innerWidth")
        assert page.evaluate_script("document.documentElement.scrollWidth <= window.innerWidth"), "Horizontal overflow at #{width}px on #{path}"
        page.execute_script("document.querySelectorAll('img').forEach(image => image.loading = 'eager')")
        assert page.evaluate_async_script("const done = arguments[0]; Promise.all(Array.from(document.images, image => image.decode())).then(() => done(true)).catch(() => done(false))"), "Missing image on #{path}"
        assert_no_selector "turbo-frame"
        assert page.evaluate_script("Array.from(document.querySelectorAll('.product-card, .product-image-link, .detail-image')).every(element => getComputedStyle(element).backgroundColor === 'rgba(0, 0, 0, 0)')")
        assert page.evaluate_script("Array.from(document.querySelectorAll('.wall-writing')).every(element => element.getAttribute('aria-hidden') === 'true' && getComputedStyle(element).pointerEvents === 'none')")
        if path == root_path
          assert_operator find("#new-arrivals-title").evaluate_script("this.getBoundingClientRect().top"), :<, height
          assert_equal width >= 1024 ? 4 : 2, page.evaluate_script("getComputedStyle(document.querySelector('.product-grid')).gridTemplateColumns.split(' ').length")
          page.execute_script("window.scrollTo(0, 450)")
          assert_in_delta 0, find(".site-header").evaluate_script("this.getBoundingClientRect().top"), 1
          assert_operator find(".hero").evaluate_script("this.getBoundingClientRect().top"), :<, 0
          page.execute_script("window.scrollTo(0, 0)")
        end
        page.save_screenshot(Rails.root.join("tmp/screenshots/frontend-#{width}-#{index}.png"))
      end
    end
  ensure
    clear_viewport
  end

  test "reduced motion disables product transitions" do
    visit shop_path
    page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [ { name: "prefers-reduced-motion", value: "reduce" } ])
    assert_equal "0s", find(".product-image", match: :first).evaluate_script("getComputedStyle(this).transitionDuration")
  ensure
    page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [])
  end

  private

  def set_viewport(width, height)
    page.current_window.resize_to(width, height)
    # Chrome's desktop window has a minimum width; emulate the exact CSS viewport.
    page.driver.browser.execute_cdp("Emulation.setDeviceMetricsOverride", width: width, height: height, deviceScaleFactor: 1, mobile: false)
  end

  def clear_viewport
    page.driver.browser.execute_cdp("Emulation.clearDeviceMetricsOverride")
  end
end
