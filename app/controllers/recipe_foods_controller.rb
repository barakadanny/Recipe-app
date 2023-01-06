class RecipeFoodsController < ApplicationController
  access user: :all, admin: :all
  def index
    @recipe=Recipe.joins(:recipe_foods).find(params[:recipe_id])
    @food=Recipe.joins(:foods).find(params[:recipe_id])

    @ar_quantity=[]
    @ar_name=[]
    @ar_price=[]

     @recipe.recipe_foods.each do |recipe_food| 
       @ar_quantity<<recipe_food.quantity
       food = Food.find(recipe_food.food_id) 
       @ar_name<<food.name
       total_price = recipe_food.quantity * food.price 
       @ar_price<<total_price 
      end 
  end

  def new
    @recipe = Recipe.find(params[:recipe_id])
    @foods = Food.where(user_id: current_user.id)
    @food_items = []
    @foods.each do |food|
      @food_items << [food.name, food.id]
    end
  end

  def create
    @recipe_foods = RecipeFood.new(recipe_food_params)
    respond_to do |format|
      if @recipe_foods.save
        # rubocop:disable Style/BlockDelimiters
        format.html {
          redirect_to recipe_url(@recipe_foods.recipe_id), notice: 'Recipe_food was successfully created.'
        }
        # rubocop:enable Style/BlockDelimiters
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def recipe_food_params
    params
      .require(:recipe_food)
      .permit(:quantity, :recipe_id, :food_id)
  end
end
