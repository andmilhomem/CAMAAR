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


  ##
  # Usuário precisa ser administrador.
  #
  # Busca os templates e as turmas disponíveis, redireciona o usuário para a tela de criação de
  # um novo formulário
  #
  # Se não existir templates ou turmas disponíveis, o usuário é redirecionado para a tela de admin
  # com a mensagem referente à o que não tem disponível
  def new
    @templates = Template.all
    @template_options = @templates.map do |template| [template.nome, template.id] end
    @turmas = Turma.all

    if @templates.blank?
      redirect_to admin_path, alert: "Nenhum template disponível!" and return 
    elsif @turmas.blank?
      redirect_to admin_path, alert: "Nenhuma turma disponível!" and return
    end
  end

  ##
  # Usuário precisa ser administrador.
  # 
  # Cria um formulário para cada turma selecionada. O formulário terá as questões (e opções, se existir) duplicadas
  # do template escolhido, para que não haja conflitos quando o template é atualizado ou removido. Após a criação do(s) formulário(s),
  # o usuário é redirecionado para a listagem de formulários.
  #
  # Se o usuário não selecionar nenhum template, ou não selecionar nenhuma turma, o usuário continuará na tela de 
  # criação de formulário e aparecerá uma mensagem de erro.
  def create
    turmas_selecionadas = params[:turma_ids]
    template_id = params[:template_id]
    if template_id.blank? or turmas_selecionadas.blank?
      redirect_to new_formulario_path, alert: "Preencha todas as informações necessárias!" and return
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
    redirect_to formularios_path, notice: "Formulário(s) criado(s) com sucesso!"
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
