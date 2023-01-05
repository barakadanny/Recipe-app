class RecipeFoodsController < ApplicationController
    def index
        @foods = current_user.recipe_foods.includes([:food])
    end

    def new
        @recipe=Recipe.find(params[:recipe_id])
        # @recipe_foods=Recipe_foods.new
        @foods=Food.where(user_id: current_user.id)
        @food_items = []
        @foods.each do |food|
        @food_items << [food.name, food.id]
    end
    end

    def create
        @recipe_foods = RecipeFood.new(recipe_food_params)
            respond_to do |format|
                if @recipe_foods.save
                  format.html { redirect_to recipe_url(@recipe_foods.recipe_id), notice: 'Recipe_food was successfully created.' }
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
