class CategoriesController < ApplicationController
  before_action :authenticate_user!, only: %i[update create destroy]
  before_action :set_category, only: %i[show edit destroy update]
  before_action :set_parent, only: :index

  # GET /categories or /categories.json
  def index
    if user_signed_in?
      if @parent
        @categories = @parent.subtypes
      else
        @categories = Category.parents.active.limit(2000)
      end
    else
      @categories = Category.parents.active.limit(2000)
    end
  end

  # GET /categories/1 or /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories or /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to category_url(@category), notice: "Category was successfully created." }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to category_url(@category), notice: "Category was successfully updated." }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_url, notice: "Category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_parent
      @parent = Category.friendly.find(params[:parent_id]) if params[:parent_id]
    end

    def set_category
      @category = Category.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:name, :image_url, :position, :hidden, :slug, :description, :subtitle)
    end
end