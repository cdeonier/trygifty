class PassesController < ApplicationController
  def index
    @passes = Pass.all
  end
  
  def destroy
    @pass = Pass.find(params[:id])
    @pass.destroy
    
    redirect_to passes_path
  end
end
