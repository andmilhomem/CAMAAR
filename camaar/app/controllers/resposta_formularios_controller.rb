##
# Controladora das ações da model RespostaFormulario

class RespostaFormulariosController < ApplicationController
  before_action :requerer_admin, only: [:index, :show]

  ##
  # Usuário precisa ser administrador
  #
  # Busca os formularios respondidos e renderiza a página resposta_formularios/index.html.haml
  def index
    @formularios = Formulario.respondidos
  end

  ##
  # Usuário precisa ser administrador
  #
  # Gera um csv com as informações das respostas relacionadas ao formulario que foi selecionado
  def show
    formulario = Formulario.find_by_id params[:id]
    respostas_csv_service = RespostaFormulariosCsvService.new(formulario)
    csv_result = respostas_csv_service.get_arquivo_csv
    request.format = :csv
    respond_to do |format|
      format.csv { send_data csv_result, :filename => (respostas_csv_service.get_nome_csv) }
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

  def resposta_formulario_params
    # Permite o formulário e o hash de respostas diretamente
    params.permit(:formulario_id, respostas: {})
  end

end
