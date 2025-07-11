class FormulariosController < ApplicationController
  before_action :requerer_admin, only: [:new, :create]

  def index
    usuario      = Usuario.find(session[:usuario_id])
    turmas_ids   = usuario.turmas.ids

    # lê do session a lista de formulários já respondidos por este usuário
    #responded_ids = session[:formularios_respondidos] || []

    # Pega da tabela associativa todos os formulários já respondidos pelo usuário
    responded_ids = usuario.formularios.ids

    @formularios = Formulario
                     .where(turma_id: turmas_ids)
                     .where.not(id: responded_ids)

    @tem_formularios = @formularios.any?
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
