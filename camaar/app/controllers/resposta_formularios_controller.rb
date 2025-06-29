class RespostaFormulariosController < ApplicationController
  before_action :requerer_admin, only: :index

  def index
  end

  def new
  end

  def create
  end

  private

  def resposta_formulario_params
    params.require(:resposta_formulario).permit(
      :formulario_id,
      resposta_questaos_attributes: [:num_questao, :texto_resposta]
    )
  end

end
