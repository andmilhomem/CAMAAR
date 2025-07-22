# Controller responsável por gerenciar templates de formulários
# Permite criar, editar, visualizar e excluir templates com questões aninhadas
class TemplatesController < ApplicationController
  # Garante que apenas administradores possam acessar as ações deste controller
  before_action :requerer_admin
  # Define o template a ser manipulado para as ações edit, update e destroy
  before_action :set_template, only: [:edit, :update, :destroy]

  # GET /templates
  # Lista todos os templates cadastrados
  def index
    @templates = Template.all
  end

  # GET /templates/new
  # Exibe o formulário para criação de um novo template
  def new
  end

  # POST /templates
  # Cria um novo template com as questões aninhadas
  #
  # @return [Redirect] Redireciona para a lista de templates em caso de sucesso
  # @return [Render] Renderiza o formulário de novo template em caso de erro
  def create
    @template = Template.new(template_params)
    
    if @template.save
      handle_successful_save('Template criado com sucesso!')
    else
      handle_failed_save('Erro ao criar template. Verifique os campos.')
    end
  end

  # GET /templates/:id/edit
  # Exibe o formulário para edição de um template existente
  def edit
  end

  # PATCH/PUT /templates/:id
  # Atualiza um template existente e suas questões aninhadas
  #
  # @return [Redirect] Redireciona para a lista de templates em caso de sucesso
  # @return [Render] Renderiza o formulário de edição em caso de erro
  def update
    remover_questoes_antigas
    if atualizar_template
      handle_successful_save('Template atualizado com sucesso!')
    else
      handle_failed_save('Erro ao atualizar template. Verifique os campos.')
    end
  end

  # DELETE /templates/:id
  # Remove um template e suas questões não utilizadas por formulários
  #
  # @return [Redirect] Redireciona para a lista de templates após a exclusão
  def destroy
    # Remove questões não utilizadas por formulários
    @template.questaos.where(formulario_id: nil).destroy_all
    @template.destroy
    redirect_to templates_path, notice: 'Template deletado com sucesso!'
  end

  private

  # Busca o template pelo ID informado nos parâmetros
  #
  # @return [Template] O template encontrado
  def set_template
    @template = Template.find(params[:id])
  end

  # Manipula o fluxo de sucesso ao salvar um template
  #
  # @param success_message [String] Mensagem de sucesso a ser exibida
  def handle_successful_save(success_message)
    if ajax_request?
      render json: { success: true, redirect_url: templates_path }
    else
      redirect_to templates_path, notice: success_message
    end
  end

  # Manipula o fluxo de erro ao salvar um template
  #
  # @param error_message [String] Mensagem de erro a ser exibida
  def handle_failed_save(error_message)
    if ajax_request?
      render json: { success: false, errors: @template.errors.full_messages }, status: :unprocessable_entity
    else
      flash.now[:alert] = error_message
      # Renderiza o formulário correto conforme a action
      if action_name == 'create'
        render :new, status: :unprocessable_entity
      elsif action_name == 'update'
        render :edit, status: :unprocessable_entity
      else
        head :unprocessable_entity
      end
    end
  end

  # Verifica se a requisição é AJAX
  #
  # @return [Boolean] true se for AJAX, false caso contrário
  def ajax_request?
    request.xhr?
  end

  # Permite apenas os parâmetros permitidos para template e questões aninhadas
  #
  # @return [ActionController::Parameters] Parâmetros permitidos
  def template_params
    params.require(:template).permit(
      :nome,
      questaos_attributes: [
        :num_questao, :tipo, :enunciado,
        opcaos_attributes: [:num_opcao, :texto_opcao]
      ]
    )
  end

  # Remove todas as questões antigas do template antes de atualizar
  def remover_questoes_antigas
    @template.remover_questoes_antigas
  end

  # Atualiza o template com os parâmetros recebidos
  #
  # @return [Boolean] true se atualizado com sucesso, false caso contrário
  def atualizar_template
    @template.update(template_params)
  end
end
