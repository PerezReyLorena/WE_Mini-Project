class WelcomeController < ApplicationController
  def index
    if current_user.present?
      render 'users/index'
    end
  end
end
