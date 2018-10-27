class CategoriesController < ApplicationController
  def show
    @categories = Category.all
    @category = Category.find(params[:id])
    @topics = @category.topics.page(params[:page]).per(20).order(:id)
  end
end
