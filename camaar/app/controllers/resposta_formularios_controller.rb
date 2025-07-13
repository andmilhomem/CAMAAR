require 'csv'

class RespostaFormulariosController < ApplicationController
  before_action :requerer_admin, only: :index
  include FormulariosHelper

  def index
    if params[:form_id].present? # Verifica se a requisição contém um form_id como parâmetro
      form_id = params[:form_id]
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

    else
      @formularios = Formulario.respondidos
    end
  end

  def new
    @formulario = Formulario.find(params[:formulario_id])
    # Carrega as questões associadas a esse formulário
    @questaos   = @formulario.questaos
  end

  def create
    permitted      = resposta_formulario_params
    @formulario    = Formulario.find(permitted[:formulario_id])
    @questaos      = @formulario.questaos
    respostas_hash = permitted[:respostas] || {}

    # Validação reforçada
    missing_ids = @questaos.map(&:id).map(&:to_s) - respostas_hash.keys
    any_blank   = respostas_hash.values.any?(&:blank?)

    if missing_ids.any? || any_blank
      flash.now[:alert] = "Todos os campos devem ser preenchidos!"
      return render :new
    end

    ActiveRecord::Base.transaction do
      resposta_form = RespostaFormulario.create!(
        formulario:    @formulario,
        data_resposta: Time.current
      )

      respostas_hash.each do |qid_str, valor|
        q = @questaos.find { |qq| qq.id == qid_str.to_i }
        RespostaQuestao.create!(
          resposta_formulario: resposta_form,
          num_questao:         q.num_questao,
          texto_resposta:      valor
        )
      end

      # Registra resposta na tabela associativa de usuários e formulários
      usuario = Usuario.find(session[:usuario_id])
      usuario.formularios << @formulario unless usuario.formularios.exists?(@formulario.id)

    end

   # session[:formularios_respondidos] ||= []
   # session[:formularios_respondidos] << @formulario.id
   # session[:formularios_respondidos].uniq!

    redirect_to formularios_path, notice: "Resposta enviada com sucesso!"
  rescue => e
    logger.error "[RESPOSTA] erro ao salvar: #{e.class} #{e.message}"
    flash.now[:alert] = "Erro ao enviar: #{e.message}"
    render :new
  end

  private

  def gera_nome_csv formulario
    formulario ? "#{formulario.turma.disciplina.nome}-#{get_nome_professor formulario.turma}.csv" : "N/A.csv"
  end

  def resposta_formulario_params
    # Permite o formulário e o hash de respostas diretamente
    params.permit(:formulario_id, respostas: {})
  end

end
