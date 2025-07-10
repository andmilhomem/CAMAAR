require 'csv'

class RespostaFormulariosController < ApplicationController
  before_action :requerer_admin, only: :index
  include FormulariosHelper

  def index
    @formularios = Formulario.respondidos
  end

  def show 
    form_id = params[:id]
    respostas = RespostaFormulario.where :formulario_id => form_id
    csv_result = CSV.generate do |csv|
      csv << ["id","data_resposta","num_questao","texto_resposta"]
      respostas.each do |rf|
        rf.resposta_questaos.each do |rq|
          csv << [rf.id,rf.data_resposta,rq.num_questao,rq.texto_resposta]
        end
      end
    end

    request.format = :csv
    respond_to do |format|
      format.csv { send_data csv_result, :filename => (gera_nome_csv Formulario.find_by_id form_id) }
    end 
  end

  def new
  end

  def create
  end

  private

  def gera_nome_csv formulario
    formulario ? "#{formulario.turma.disciplina.nome}-#{get_nome_professor formulario.turma}.csv" : "N/A.csv"
  end

  def resposta_formulario_params
    params.require(:resposta_formulario).permit(
      :formulario_id,
      resposta_questaos_attributes: [:num_questao, :texto_resposta]
    )
  end

end
