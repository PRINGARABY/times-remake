class Category < ApplicationRecord
  has_many :products, dependent: :restrict_with_error

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true, format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ }
end
