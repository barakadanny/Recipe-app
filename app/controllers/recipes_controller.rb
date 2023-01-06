class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[show
                                      edit
                                      update
                                      destroy]

  access all: [:index], user: :all, admin: :all

  # GET /recipes or /recipes.json
  def index
    @recipes = if current_user
                 Recipe.where(user_id: current_user.id)
               else
                 []
               end
  end

  # GET /recipes/1 or /recipes/1.json
  def show
    # @recipe_foods=RecipeFood.where(recipe_id: params[:id])
    @recipe = Recipe.joins(:foods).find(params[:id])
    # @recipe_foods = @recipe.recipe_foods.includes(:food)
  end

  # Get /Public recipes
  def public_recipes
    @recipes = Recipe.includes(:user).where(public: true)
    @recipe_foods=RecipeFood.all
    # @food=Food.where
    # @foods = current_user.recipe_foods.includes([:food])
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit; end

  # POST /recipes or /recipes.json
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
