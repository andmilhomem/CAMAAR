require 'csv'

class RespostaFormulariosController < ApplicationController
  before_action :requerer_admin, only: :index

  def index
    @formularios = Formulario.respondidos
  end

  def show 
    form_id = params[:id]
    respostas = RespostaFormulario.where :formulario_id => form_id
    csv_result = CSV.generate do |csv|
      
    end
    send_data "hellooo", :filename => gera_nome_csv Formulario.find_by_id form_id
  end

  def new
  end

  def create
  end

  private

  def gera_nome_csv formulario
    formulario ? "#{formulario.turma.disciplina.nome}-#{get_nome_professor formulario.turma}.csv" : "N/A.csv"
  end
    
  end

  def resposta_formulario_params
    params.require(:resposta_formulario).permit(
      :formulario_id,
      resposta_questaos_attributes: [:num_questao, :texto_resposta]
    )
  end

end
