class FormulariosController < ApplicationController
  before_action :requerer_admin, only: [:new, :create]
  
  def index
  end

  def new
  end

  def create
  end

  private

  def formulario_params
    params.require(:formulario).permit(
      :turma_id,
      questaos_attributes: [
        :num_questao, :tipo, :enunciado,
        opcaos_attributes: [:num_opcao, :texto_opcao]
      ]
    )
  end
end
