class SessoesController < ApplicationController
  skip_before_action :requerer_login, only: [:new, :create]
  skip_before_action :requerer_usuario_ativo, only: [:new, :create, :destroy]

  def new
    # Apenas renderiza o formulário de login
  end

  def create
    usuario = Usuario.find_by(email: params[:email])

    if usuario && usuario.authenticate(params[:password])
      session[:usuario_id] = usuario.id

      if !usuario.esta_ativo?
        redirect_to redefinir_senha_path

      elsif usuario.admin?
        redirect_to admin_path
      else
        redirect_to root_path
      end
    else
      flash.now[:alert] = "Email ou senha inválidos!"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:usuario_id] = nil
    redirect_to login_path, notice: "Logout efetuado com sucesso!"
  end
end