class SessoesController < ApplicationController
  skip_before_action :requerer_login, only: [:new, :create]
  skip_before_action :requerer_usuario_ativo, only: [:new, :create]

  def new
  end

  def create
  end

  def destroy
  end
end
