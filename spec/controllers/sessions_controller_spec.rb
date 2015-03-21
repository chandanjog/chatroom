require 'rails_helper'

describe SessionsController, type: :controller do

  describe 'GET #new' do
    it 'assigns dialect options' do
      get :new
      expect(assigns(:dialect_options)).to eq(SessionsController::DIALECT_OPTIONS)
      expect(response).to render_template('new')
    end
  end

  describe 'POST #create' do
    it 'should redirect to chatroom/index after storing values in session on success' do
      expect(session['username']).to eq(nil)
      expect(session['dialect_slug']).to eq(nil)

      post :create, username: 'foo', dialect_slug: 'pirate'

      expect(session['username']).to eq('foo')
      expect(session['dialect_slug']).to eq('pirate')
      expect(response).to redirect_to(chatroom_index_url)
    end

    it 'should render to login form with error message for empty username' do
      post :create, username: '', dialect_slug: 'pirate'

      expect(assigns(:error_message)).to eq(SessionsController::MISSING_USERNAME_OR_DIALECT_ERROR_MSG)
      expect(assigns(:dialect_options)).to eq(SessionsController::DIALECT_OPTIONS)
      expect(response).to render_template('new')
    end

    it 'should render to login form with error message for empty dialect_slug' do
      post :create, username: 'foo', dialect_slug: ''

      expect(assigns(:error_message)).to eq(SessionsController::MISSING_USERNAME_OR_DIALECT_ERROR_MSG)
      expect(assigns(:dialect_options)).to eq(SessionsController::DIALECT_OPTIONS)
      expect(response).to render_template('new')
    end
  end
end
