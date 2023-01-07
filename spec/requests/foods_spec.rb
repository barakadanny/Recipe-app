require 'rails_helper'

RSpec.describe 'Foods', type: :request do
  describe "GET #index" do
    it "redirect guest user to login page" do
      get 'http://www.example.com/login'
      expect(response).to render_template "devise/shared/_links"
    end
  end

  describe "redirect guest user trying to create a food" do
    it "renders the new template" do
      get 'http://www.example.com/login'
      expect(response).to render_template "devise/shared/_links"
    end
  end

  describe 'GET index' do
    before(:each) do
      user = User.create name: 'Tom', email: 'tom@example.com', password: '123456'
      post user_session_path, params: { user: { email: user.email, password: user.password } }
      get root_path
    end

    it 'should return http request' do
      expect(response).to have_http_status(:success)
    end

    it 'should render correct path' do
      expect(response).to render_template(:index)
    end

    it 'should render correct template' do
      expect(response).to render_template('index')
    end
  end
end
