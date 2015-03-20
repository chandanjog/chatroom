class HomeController < ApplicationController
  def index
    @dialect_options = [['Pirate', 'pirate'], ['Yoda', 'yoda'], ['Valley Girl', 'valley-girl']]
    render layout: 'home'
  end
end
