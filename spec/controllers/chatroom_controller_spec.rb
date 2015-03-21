require 'rails_helper'
require_relative '../../app/models/comment'

describe ChatroomController, type: :controller do

  describe 'GET #index' do
    it 'should render template if a session username exists' do
      session['username'] = 'foo'
      get :index
      expect(response).to render_template('index')
    end

    it 'should redirect to sessions/new if a session username does not exist' do
      (1..5).each {|x| Comment.create!(username: 'foo', message: "#{x} foo bar zoo", dialect: 'pirate')}

      get :index

      expect(assigns['latest_comments'].count).to eq(5)
      expect(assigns['latest_comments'].first.message).to eq('5 foo bar zoo')
      expect(response).to redirect_to('/sessions/new')
    end
  end

  describe 'POST #comment' do
    it 'should translate the message and update the db' do
      expect(Comment.all.count).to eq(0)
      session['username'] = 'foo'
      session['dialect_slug'] = 'pirate'

      post :comment, message: 'hello people'
      expect(Comment.all.count).to eq(1)
      expect(Comment.first.username).to eq('foo')
      expect(Comment.first.dialect).to eq('pirate')
      expect(Comment.first.message).to match(/^a(hoy|vast) people/)
      expect(Comment.first.created_at).to_not be nil
    end
  end
end
