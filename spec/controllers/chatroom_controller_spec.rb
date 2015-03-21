require 'rails_helper'

describe ChatroomController, type: :controller do

  describe 'GET #index' do
    it 'should render template if a session username exists' do
      session['username'] = 'foo'
      get :index
      expect(response).to render_template('index')
    end

    it 'should redirect to sessions/new if a session username does not exist' do
      get :index
      expect(response).to redirect_to('/sessions/new')
    end
  end
end
