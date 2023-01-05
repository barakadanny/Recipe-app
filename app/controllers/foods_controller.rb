class FoodsController < ApplicationController
  access user: :all, admin: :all
  def index
    @user = current_user
    @food = Food.all
  end

  def create
    @food = Food.new(food_params)
    respond_to do |format|
      format.html do
        if @food.save
          redirect_to foods_path(current_user, @food)
        else
          redirect_to new_food_path(current_user)
        end
      end
    end
  end

  def food_params
    params.permit(:name, :measurement_unit, :price, :quantity).merge(user_id: current_user.id)
  end

  def destroy
    @food = Food.find(params[:id])
    @food.destroy

    respond_to do |format|
      format.html { redirect_to foods_url, notice: 'Food was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
