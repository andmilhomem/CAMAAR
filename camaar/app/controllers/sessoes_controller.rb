class SessoesController < ApplicationController
  skip_before_action :requerer_login, only: [:new, :create]
  skip_before_action :requerer_usuario_ativo, only: [:new, :create]

  def new
  end

  def create
    usuario = Usuario.find_by(email: params[:email])

    if usuario&.authenticate(params[:senha])
      session[:usuario_id] = usuario.id
      redirect_to formularios_path
    else
      flash[:alert] = "Credenciais inválidas"
      render :new
    end
  end

  def destroy
  end
end
