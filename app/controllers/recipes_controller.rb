class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[show
                                      edit
                                      update
                                      destroy]

  access all: [:index], user: :all, admin: :all

  def index
    @recipes = if current_user
                 Recipe.where(user_id: current_user.id)
               else
                 []
               end
  end

  def show
    begin
      @recipe = Recipe.joins(:foods).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @recipe = Recipe.find(params[:id])
    end
      # @recipe = Recipe.find(params[:id])
      # @total_price = 0

      # @recipe.recipe_foods.each do |recipe_food|
      #   food = Food.find(recipe_food.food_id)
      #   @total_price += recipe_food.quantity * food.price
      # end
      @recipe.foods.each do |food|
        recipe_food = @recipe.recipe_foods.find_by(food_id: food.id)
        total_price = food.price * recipe_food.quantity
        # Now you can use total_price in your view to display the total price for each recipe food
      end
  end

  def public_recipes
    @recipes = Recipe.includes(:user).where(public: true)
    @recipe_counts = RecipeFood.group(:recipe_id).count

    @total_prices = {}
    @recipes.each do |recipe|
      @total_prices[recipe.id] = recipe.foods.sum { |food| food.price * recipe.recipe_foods.find_by(food_id: food.id).quantity }
    end
  end

  def new
    @recipe = Recipe.new
  end

  def edit; end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to recipe_url(@recipe), notice: 'Recipe was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # rubocop:disable Style/NegatedIfElseCondition
  def update
    @recipe = Recipe.find(params[:id])
    respond_to do |format|
      if @recipe.user_id != current_user.id
        format.html { redirect_to recipe_url(@recipe), notice: 'You are not the owner of this recipe.' }
      else
        # rubocop:disable Style/IfInsideElse
        if @recipe.update(recipe_params)
          format.html { redirect_to recipe_url(@recipe), notice: 'Recipe was successfully updated.' }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
        # rubocop:enable Style/IfInsideElse
      end
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    if @recipe.user_id != current_user.id
      redirect_to recipe_url(@recipe), notice: 'You are not the owner of this recipe.'
    else
      @recipe.destroy
      respond_to do |format|
        format.html { redirect_to recipes_url, notice: 'Recipe was successfully destroyed.' }
      end
    end
  end
  # rubocop:enable Style/NegatedIfElseCondition

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :description, :public)
  end
end
