class TemplatesController < ApplicationController
  before_action :requerer_admin

  def index
    @templates = Template.all
  end

  def new
  end

  def create
    @template = Template.new(template_params)
    if @template.save
      if request.xhr?
        render json: { success: true, redirect_url: templates_path }
      else
        redirect_to templates_path, notice: 'Template criado com sucesso!'
      end
    else
      if request.xhr?
        render json: { success: false, errors: @template.errors.full_messages }, status: :unprocessable_entity
      else
        flash.now[:alert] = 'Erro ao criar template. Verifique os campos.'
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
    @template = Template.find(params[:id])
  end

  def update
    @template = Template.find(params[:id])
    @template.questaos.destroy_all # Apaga as questões antigas para evitar duplicidade

    if @template.update(template_params)
      if request.xhr?
        render json: { success: true, redirect_url: templates_path }
      else
        redirect_to templates_path, notice: 'Template atualizado com sucesso!'
      end
    else
      if request.xhr?
        render json: { success: false, errors: @template.errors.full_messages }, status: :unprocessable_entity
      else
        flash.now[:alert] = 'Erro ao atualizar template. Verifique os campos.'
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @template = Template.find(params[:id])
    # Apaga questões (e dependentes) que não foram usadas por formulários
    @template.questaos.where(formulario_id: nil).destroy_all
    # Deleta apenas o template (não seus dependentes)
    @template.delete
    redirect_to templates_path, notice: 'Template deletado com sucesso!'
  end

  private

  def template_params
    params.require(:template).permit(
      :nome,
      questaos_attributes: [
        :num_questao, :tipo, :enunciado,
        opcaos_attributes: [:num_opcao, :texto_opcao]
      ]
    )
  end

end
