require 'rails_helper'
require_relative '../../app/models/comment'

describe ChatroomController, type: :controller do

  describe 'GET #index' do
    it 'should render template if a session username exists' do
      username = 'foo'
      MongoidStore::Session.create(data: BSON::Binary.new(Marshal::dump({'username' => username})))
      session['username'] = username
      (1..5).each {|x| Comment.create!(username: username, message: "#{x} foo bar zoo", dialect: 'pirate')}

      get :index

      expect(assigns['latest_comments'].count).to eq(5)
      expect(assigns['latest_comments'].first.message).to eq('5 foo bar zoo')
      expect(assigns['active_usernames'].count).to eq(1)
      expect(assigns['active_usernames'].first).to eq(username)
      expect(response).to render_template('index')
    end

    it 'should redirect to sessions/new if a session username does not exist' do
      get :index
      expect(response).to redirect_to('/sessions/new')
    end
  end

  describe 'POST #comment' do
    it 'should translate the message and update the db, and push to clients on websocket' do
      Timecop.freeze(Time.local(2008, 9, 1, 12, 0, 0)) do
        expect(WebsocketRails[:posts]).to receive(:trigger).with('new', "<li class=\"media\" id=\"user_post\">\n    <span class=\"pull-left\">\n        <img class=\"media-object post_dialect\" width=\"48px\" src=\"/assets/valley-girl.ico\" alt=\"Valley girl\" />\n    </span>\n    <div class=\"media-body\">\n        <h4 class=\"media-heading post_username\">\n            foo\n            <small class=\"text-muted post_created_at\">on 09/01/2008 at 10:00AM</small>\n        </h4>\n        <p class=\"post_message\">hello people</p>\n    </div>\n</li>\n")

        expect(Comment.all.count).to eq(0)
        session['username'] = 'foo'
        session['dialect_slug'] = 'valley-girl'

        post :comment, message: 'hello people'
        expect(Comment.all.count).to eq(1)
        expect(Comment.first.username).to eq('foo')
        expect(Comment.first.dialect).to eq('valley-girl')
        expect(Comment.first.message).to eq('hello people')
        expect(Comment.first.created_at).to_not be nil
        expect(JSON.parse(response.body)).to eq('success' => true)
      end
    end

    it 'should not allow messages greater than allowed limit' do
      session['username'] = 'foo'
      session['dialect_slug'] = 'valley-girl'

      post :comment, message: 'hello'*1000
      expect(JSON.parse(response.body)).to eq('success' => false, 'error_message' => ChatroomController::MESSAGE_TOO_BIG_ERROR_MESSAGE)
    end
  end
end
