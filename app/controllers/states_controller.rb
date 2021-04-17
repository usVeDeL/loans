class StatesController < ApplicationController
  before_action :is_view_permitted?, only:[:new, :edit, :index, :destroy]
  
  def index
    @states = State.all
  end

  def new
    @state = State.new
  end

  def create
    @state = State.new(state_params)
  
    if @state.save
      flash[:success] = success_text

      redirect_to states_path
    else
      render 'new'
    end
  end

  def edit
    @state = State.find(params[:id])
  end

  def update
    @state = State.find(params[:id])

    if @state.update(state_params)
      flash[:success] = success_text

      redirect_to states_path
    else
      render 'edit'
    end
  end

  def destroy
    state = State.find(params[:id])

    if state.delete
      flash[:success] = success_text

      redirect_to states_path
    else
      flash[:danger] = error_text

      redirect_to states_path
    end
  end

  private

  def state_params
    params.require(:state).permit(
      :name,
      :active
    )
  end
end
