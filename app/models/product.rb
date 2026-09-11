class Product < ApplicationRecord
  DIRECTIONS = { "remake" => "Remake", "archive" => "Archive", "brand_collection" => "Brand Collection" }.freeze
  SORT_OPTIONS = { "newest" => "Newest first", "price_asc" => "Price: low to high", "price_desc" => "Price: high to low" }.freeze

  belongs_to :brand
  belongs_to :category
  has_many_attached :images

  enum :direction, DIRECTIONS.keys.index_with(&:itself), validate: true
  enum :status, { draft: "draft", available: "available", sold: "sold" }, validate: true

  validates :name, :slug, :description, :currency, presence: true
  validates :slug, uniqueness: true, format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ }
  validates :price_cents, :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :condition_score, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }, allow_nil: true
  validates :currency, inclusion: { in: [ "CNY" ] }
  validate :measurements_are_an_object

  scope :published, -> { where(status: %w[available sold]) }
  scope :in_stock, -> { where(status: "available").where("quantity > 0") }
  scope :highlighted, -> { where(featured: true) }
  scope :by_brand, ->(slug) { joins(:brand).where(brands: { slug: slug }) }
  scope :by_category, ->(slug) { joins(:category).where(categories: { slug: slug }) }
  scope :by_direction, ->(direction) { where(direction: direction) }

  def self.sorted_by(sort)
    case sort
    when "price_asc" then order(price_cents: :asc, id: :desc)
    when "price_desc" then order(price_cents: :desc, id: :desc)
    else order(created_at: :desc, id: :desc)
    end
  end

  def to_param
    slug
  end

  def one_of_one?
    quantity == 1
  end

  def in_stock?
    available? && quantity.positive?
  end

  def direction_label
    DIRECTIONS.fetch(direction)
  end

  def availability_label
    return "SOLD" if sold?

    in_stock? ? "AVAILABLE" : "UNAVAILABLE"
  end

  def archive_code
    "TR-%05d" % id
  end

  private

  def measurements_are_an_object
    errors.add(:measurements, "must be an object with measurement names and values") unless measurements.is_a?(Hash)
  end
end
