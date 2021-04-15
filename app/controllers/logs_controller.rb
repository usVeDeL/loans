class LogsController < ApplicationController
  before_action :permitted_view

  def index
    @logs = Log.all.order('created_at desc')
  end

  private

  def permitted_view
    redirect_to root_path unless current_user.role_name == 'gerencia'
  end
end
