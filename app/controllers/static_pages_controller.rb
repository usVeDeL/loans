class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    redirect_to index_path if signed_in?
  end

  def index
  end
end
