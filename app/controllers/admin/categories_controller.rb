class Admin::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin
  before_action :set_category, only: [:update, :destroy]

  def index
    @categories = Category.all
    
    # 這裡是new or edit 的form所需要的值，如果有url有id就將form帶入edit，沒有就new。
    if params[:id]
      set_category
    else
      @category = Category.new
    end
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "category was successfully created"
      redirect_to admin_categories_path
    
    else
      @categories = Category.all
      render :index
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path
      flash[:notice] = "category was successfully updated"
    else
      @categories = Category.all.order(:id)
      render :index
    end
  end

  def destroy
    if @category.destroy
      flash[:alert] = "category was successfully deleted"
    else
      flash[:alert] = @category.errors.full_messages.to_sentence
    end
    
    redirect_to admin_categories_path
  end


  private

  def authenticate_admin
    unless current_user.admin?
      flash[:alert] = "Not allow!"
      redirect_to root_path
    end
  end

  def set_category 
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
