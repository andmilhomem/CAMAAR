class SessoesController < ApplicationController

  skip_before_action :requerer_login, only: [:new, :create, :login_para_teste]
  skip_before_action :requerer_usuario_ativo, only: [:new, :create, :destroy, :login_para_teste]

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

  # Válido apenas em ambiente de teste. Os testes do RSpec dependem do método (Cucumber não)
  # Basta passar email do usuário como parâmetro.
  # Rota: post "/login_para_teste", params: {email: @usuario.email}
  def login_para_teste
    usuario = Usuario.find_by(email: params[:email])

    if usuario
      session[:usuario_id] = usuario.id
      redirect_to root_path, notice: "Login realizado com sucesso!"
    else
      puts "ERRO NO LOGIN DE TESTE"
      redirect_to login_path, alert: "Usuário não encontrado"
    end   

  end

end
