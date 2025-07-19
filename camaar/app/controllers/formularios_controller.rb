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
    load_form_options
  end

  def create
    turmas_selecionadas = params[:turma_ids]
    template_id = params[:template_id]
    if template_id.blank?
      redirect_to new_formulario_path, alert: "Selecione um template" and return
    end
    if turmas_selecionadas.blank?
      redirect_to new_formulario_path, alert: "Selecione ao menos uma turma" and return
    end

    formularios = []
    turmas_selecionadas.each do |turma_id|
      formularios << Formulario.create(turma_id: turma_id)
    end

    template = Template.find(template_id)

    formularios.each do |formulario|
      template.questaos.each do |questao|
        q_form = questao.dup
        q_form.template_id = nil
        q_form.formulario_id = formulario.id
        q_form.save
        if q_form.tipo.eql? "Radio"
          questao.opcaos.each do |opcao|
            op_form = opcao.dup
            op_form.questao_id = q_form.id
            op_form.save
          end
        end
      end
    end
    redirect_to formularios_path, notice: formularios
  end

  private

  def load_form_options
    @templates = Template.all
    @template_options = @templates.map do |template| [template.nome, template.id] end
    @turmas = Turma.all
  end

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
