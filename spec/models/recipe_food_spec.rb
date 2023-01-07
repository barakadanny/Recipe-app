require 'rails_helper'

RSpec.describe RecipeFood, type: :model do
  describe RecipeFood do
    describe 'associations' do
      it 'belongs to food' do
        food = Food.new
        recipe_food = RecipeFood.new(food: food)
        expect(recipe_food.food).to eq(food)
      end
  
      it 'belongs to recipe' do
        recipe = Recipe.new
        recipe_food = RecipeFood.new(recipe: recipe)
        expect(recipe_food.recipe).to eq(recipe)
      end
    end
  end
end
