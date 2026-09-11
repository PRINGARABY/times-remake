module ProductsHelper
  def product_price(product)
    number_to_currency(BigDecimal(product.price_cents.to_s) / 100, unit: "¥", precision: 2, format: "%u%n")
  end

  def product_image(product, **options)
    if product.images.attached?
      image_tag product.images.first, alt: product.name, **options
    else
      image_tag "product-placeholder.svg", alt: "Neutral placeholder — no product photograph", **options
    end
  end
end
