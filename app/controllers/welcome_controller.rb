class WelcomeController < ApplicationController
  def index
    if current_user.present?
      render 'welcome/home'
    end
  end
  def rules
    render 'welcome/rules'
  end
end
