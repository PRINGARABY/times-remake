class CreateCatalog < ActiveRecord::Migration[8.1]
  def change
    create_table :brands do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.timestamps
    end
    add_index :brands, :slug, unique: true

    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.timestamps
    end
    add_index :categories, :slug, unique: true

    create_table :products do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description, null: false
      t.string :direction, null: false
      t.integer :price_cents, null: false
      t.string :currency, null: false, default: "CNY"
      t.string :size_label
      t.jsonb :measurements, null: false, default: {}
      t.string :era
      t.decimal :condition_score, precision: 3, scale: 1
      t.text :condition_notes
      t.integer :quantity, null: false, default: 1
      t.string :status, null: false, default: "draft"
      t.boolean :featured, null: false, default: false
      t.references :brand, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.timestamps
    end

    add_index :products, :slug, unique: true
    add_index :products, :direction
    add_index :products, [ :status, :created_at ]
    add_index :products, :price_cents
    add_index :products, :featured, where: "featured = true"
    add_check_constraint :products, "price_cents >= 0", name: "products_non_negative_price"
    add_check_constraint :products, "quantity >= 0", name: "products_non_negative_quantity"
    add_check_constraint :products, "condition_score BETWEEN 1 AND 10", name: "products_condition_range"
    add_check_constraint :products, "direction IN ('remake', 'archive', 'brand_collection')", name: "products_valid_direction"
    add_check_constraint :products, "status IN ('draft', 'available', 'sold')", name: "products_valid_status"
    add_check_constraint :products, "currency = 'CNY'", name: "products_valid_currency"
    add_check_constraint :products, "jsonb_typeof(measurements) = 'object'", name: "products_measurements_object"
  end
end
