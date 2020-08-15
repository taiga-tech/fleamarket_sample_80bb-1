class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :move_to_index, except: [:index, :show, :search]

  def index
    @items = Item.includes(:user).order('created_at DESC')
  end

  def show
    @comment = Comment.new 
    @comments = @item.comments.includes(:user) 
    @like = Like.new  
  end

  #商品出品
  def new
    @category_parents = Category.where(ancestry: nil)
    # end
    if current_user
      @item = Item.new
      @item.images.new
    else
      redirect_to root_path
    end
  end

  # ajax
  def get_category_children
    @category_children = Category.find(params[:parent_id]).children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find(params[:child_id]).children
  end

  #商品情報
  def create
    @item = Item.new(item_params) 
    @post.user_id = current_user.id 
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  #商品編集
  def edit
  end

  #商品更新機能
  def update
    if @item.update(item_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  #商品削除
  def destroy
    @item.destroy
    redirect_to root_path
  end
  def search  
    @items = Item.search(params[:keyword]) 
end 
  #ストロングパラメーター
  private
  def item_params
    params.require(:item).permit(
      :title,
      :price,
      :text,
      :stock,
      :brand,
      :condition,
      :leadtime,
      :delivery_id,
      :category_id,
      images_attributes:  [:image, :_destroy, :id],
    ).merge(user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end
end
