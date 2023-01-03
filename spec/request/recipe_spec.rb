require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  describe 'GET /recipes' do
    it 'returns a list of recipes' do
      recipe1 = Recipe.create!(name: 'Recipe 1', preparation_time: 30, cooking_time: 60, description: 'Description 1', public: true)
      recipe2 = Recipe.create!(name: 'Recipe 2', preparation_time: 45, cooking_time: 90, description: 'Description 2', public: false)

      # send a GET request to the /recipes endpoint
      get '/recipes'

      # expect the response to be successful
      expect(response).to be_successful

    end
  end
end