class WelcomeController < ApplicationController
  def index
    if current_user.present?
      render 'welcome/home'
    end
  end
  def rules
    skip_before_action :authorize
  end
end
