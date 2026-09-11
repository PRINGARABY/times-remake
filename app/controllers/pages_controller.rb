class PagesController < ApplicationController
  def home
    products = Product.published.includes(:brand, :category).with_attached_images
    @new_arrivals = products.sorted_by("newest").limit(4)
    @archive_products = products.by_direction("archive").sorted_by("newest").limit(4)
  end
end
