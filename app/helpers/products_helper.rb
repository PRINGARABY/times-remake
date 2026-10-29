module ProductsHelper
  def product_display_name(product)
    product.name.delete_prefix("Demo — ")
  end

  def product_price(product)
    number_to_currency(BigDecimal(product.price_cents.to_s) / 100, unit: "¥", precision: 2, format: "%u%n")
  end

  def product_image(product, **options)
    if product.images.attached?
      image_tag product.images.first, alt: product.name, **options
    else
      image_tag "product-placeholder.svg", alt: "Product image not yet available", **options
    end
  end
end
