require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  describe 'GET/recipes' do
    it 'returns a list of recipes' do
      # send a GET request to the /recipes endpoint
      get '/recipes'

      # expect the response to be successful
      expect(response).to be_successful
    end
  end
end
