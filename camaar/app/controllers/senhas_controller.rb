class SenhasController < ApplicationController
  skip_before_action :requerer_usuario_ativo, only: [:new, :create]
  
  def new
  end

  def create
  end
end
