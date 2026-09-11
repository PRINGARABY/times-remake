class ProductsController < ApplicationController
  def index
    @filters = params.permit(:brand, :category, :direction, :available, :sort).to_h
    @brands = Brand.order(:name)
    @categories = Category.order(:name)
    @products = Product.published.includes(:brand, :category).with_attached_images
    @products = @products.by_brand(@filters["brand"]) if @filters["brand"].present?
    @products = @products.by_category(@filters["category"]) if @filters["category"].present?
    @products = @products.by_direction(@filters["direction"]) if @filters["direction"].present?
    @products = @products.in_stock if @filters["available"] == "1"
    @products = @products.sorted_by(@filters["sort"])
  end

  def show
    @product = Product.published.includes(:brand, :category).with_attached_images.find_by!(slug: params[:slug])
  end
end
