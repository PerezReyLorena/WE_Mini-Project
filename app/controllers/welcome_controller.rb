class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    if current_user.present?
      render 'welcome/home'
    end
  end
  def rules

  end
end
