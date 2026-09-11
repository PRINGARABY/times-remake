# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_10_155235) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "brands", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_brands_on_slug", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.bigint "brand_id", null: false
    t.bigint "category_id", null: false
    t.text "condition_notes"
    t.decimal "condition_score", precision: 3, scale: 1
    t.datetime "created_at", null: false
    t.string "currency", default: "CNY", null: false
    t.text "description", null: false
    t.string "direction", null: false
    t.string "era"
    t.boolean "featured", default: false, null: false
    t.jsonb "measurements", default: {}, null: false
    t.string "name", null: false
    t.integer "price_cents", null: false
    t.integer "quantity", default: 1, null: false
    t.string "size_label"
    t.string "slug", null: false
    t.string "status", default: "draft", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["direction"], name: "index_products_on_direction"
    t.index ["featured"], name: "index_products_on_featured", where: "(featured = true)"
    t.index ["price_cents"], name: "index_products_on_price_cents"
    t.index ["slug"], name: "index_products_on_slug", unique: true
    t.index ["status", "created_at"], name: "index_products_on_status_and_created_at"
    t.check_constraint "condition_score >= 1::numeric AND condition_score <= 10::numeric", name: "products_condition_range"
    t.check_constraint "currency::text = 'CNY'::text", name: "products_valid_currency"
    t.check_constraint "direction::text = ANY (ARRAY['remake'::character varying, 'archive'::character varying, 'brand_collection'::character varying]::text[])", name: "products_valid_direction"
    t.check_constraint "jsonb_typeof(measurements) = 'object'::text", name: "products_measurements_object"
    t.check_constraint "price_cents >= 0", name: "products_non_negative_price"
    t.check_constraint "quantity >= 0", name: "products_non_negative_quantity"
    t.check_constraint "status::text = ANY (ARRAY['draft'::character varying, 'available'::character varying, 'sold'::character varying]::text[])", name: "products_valid_status"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "products", "brands"
  add_foreign_key "products", "categories"
end
