# All names, brands, prices and condition details below are fictional teaching data.
ActiveRecord::Base.transaction do
  brands = [ "Second Form Studio", "Meridian Archive", "Common Thread", "Still Objects" ].to_h do |name|
    brand = Brand.find_or_initialize_by(slug: name.parameterize)
    brand.update!(name: name, description: "Fictional demonstration brand for this unofficial educational concept.")
    [ name, brand ]
  end

  categories = [ "T-Shirts", "Longsleeves", "Jackets", "Denim", "Accessories" ].to_h do |name|
    category = Category.find_or_initialize_by(slug: name.parameterize)
    category.update!(name: name)
    [ name, category ]
  end

  examples = [
    { name: "Demo — Reconstructed Work Jacket", brand: "Second Form Studio", category: "Jackets", direction: "remake", price_cents: 168000, size_label: "M", era: "Reworked / 2020s", condition_score: 8.5, quantity: 1, featured: true, measurements: { chest: "58 cm", length: "66 cm", sleeve: "61 cm" }, condition_notes: "Example: visible panel seams, softened cuffs and a repaired pocket." },
    { name: "Demo — Faded Tour T-Shirt", brand: "Meridian Archive", category: "T-Shirts", direction: "archive", price_cents: 68000, size_label: "L", era: "1990s (fictional)", condition_score: 7.0, quantity: 1, featured: true, measurements: { chest: "56 cm", length: "72 cm" }, condition_notes: "Example: faded fabric, small pinhole near hem. No real band artwork used." },
    { name: "Demo — Raw Selvedge Denim", brand: "Common Thread", category: "Denim", direction: "brand_collection", price_cents: 128000, size_label: "W32", era: "Contemporary", condition_score: 10.0, quantity: 4, featured: true, measurements: { waist: "82 cm", inseam: "80 cm", rise: "30 cm" }, condition_notes: "Example: unworn, rigid denim. Measurements are illustrative." },
    { name: "Demo — Panelled Longsleeve", brand: "Second Form Studio", category: "Longsleeves", direction: "remake", price_cents: 89000, size_label: "S", era: "Reworked / 2020s", condition_score: 9.0, quantity: 1, measurements: { chest: "51 cm", length: "67 cm" }, condition_notes: "Example: contrasting panels and light wear at neckline." },
    { name: "Demo — Field Parka", brand: "Meridian Archive", category: "Jackets", direction: "archive", price_cents: 248000, size_label: "XL", era: "1980s (fictional)", condition_score: 6.5, quantity: 0, status: "sold", measurements: { chest: "68 cm", length: "92 cm", sleeve: "64 cm" }, condition_notes: "Example: repaired elbow, patinated hardware and a missing liner. Sold demonstration record." },
    { name: "Demo — Silver-Tone Cuff", brand: "Still Objects", category: "Accessories", direction: "brand_collection", price_cents: 46000, size_label: "ONE SIZE", era: "Contemporary", condition_score: 9.5, quantity: 3, measurements: { inner_circumference: "16 cm", opening: "3 cm" }, condition_notes: "Example: brushed metal finish. Material is illustrative, not a precious-metal claim." },
    { name: "Demo — Patched Straight Denim", brand: "Second Form Studio", category: "Denim", direction: "remake", price_cents: 138000, size_label: "W30", era: "Reworked / 2020s", condition_score: 8.0, quantity: 1, measurements: { waist: "77 cm", inseam: "76 cm" }, condition_notes: "Example: reinforced knees, irregular fading and a repaired hem." },
    { name: "Demo — Washed Cotton Longsleeve", brand: "Common Thread", category: "Longsleeves", direction: "brand_collection", price_cents: 52000, size_label: "M", era: "Contemporary", condition_score: 10.0, quantity: 5, measurements: { chest: "54 cm", length: "70 cm", sleeve: "62 cm" }, condition_notes: "Example: unworn washed cotton with no recorded defects." },
    { name: "Demo — Worn Leather Belt", brand: "Still Objects", category: "Accessories", direction: "archive", price_cents: 38000, size_label: "85 cm", era: "2000s (fictional)", condition_score: 7.5, quantity: 1, measurements: { length: "100 cm", width: "3 cm" }, condition_notes: "Example: surface creasing, buckle marks and softened edges." }
  ]

  examples.each do |attributes|
    product = Product.find_or_initialize_by(slug: attributes.fetch(:name).parameterize)
    product.update!(
      attributes.except(:brand, :category).reverse_merge(status: "available", featured: false).merge(
        brand: brands.fetch(attributes.fetch(:brand)),
        category: categories.fetch(attributes.fetch(:category)),
        currency: "CNY",
        description: "Demonstration piece for an unofficial educational concept. This fictional item explores #{attributes.fetch(:direction).tr('_', ' ')} clothing and accessories. It is not actual Times Remake inventory and is not offered for sale."
      )
    )
  end
end

puts "Demo catalog ready: #{Brand.count} brands, #{Category.count} categories, #{Product.count} products."
