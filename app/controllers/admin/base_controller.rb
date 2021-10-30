class Admin::BaseController < ApplicationController
  skip_before_action :set_search
  skip_before_action :set_variable_to_javascript
  before_action :check_admin
  layout 'admin/layouts/application'

  private

  def check_admin
    redirect_to root_url unless current_user&.admin?
  end
end
