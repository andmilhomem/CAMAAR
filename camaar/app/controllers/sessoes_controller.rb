##
# Controller responsável pelas sessões de usuário (login, logout, etc)
#
# Métodos principais:
# - new: Exibe o formulário de login
# - create: Realiza o login do usuário
# - destroy: Realiza o logout
# - login_para_teste: Login especial para testes automatizados

class SessoesController < ApplicationController

  skip_before_action :requerer_login, only: [:new, :create, :login_para_teste]
  skip_before_action :requerer_usuario_ativo, only: [:new, :create, :destroy, :login_para_teste]

  ##
  # Exibe o formulário de login para o usuário.
  # GET /login
  def new
    # Apenas renderiza o formulário de login
  end

  ##
  # Realiza o login do usuário.
  # POST /login
  # Parâmetros:
  # - email: Email do usuário
  # - password: Senha do usuário
  #
  # Redireciona conforme o tipo e status do usuário:
  # - Se não estiver ativo, redireciona para redefinir senha
  # - Se for admin, redireciona para área administrativa
  # - Caso contrário, redireciona para a página principal
  #
  # Em caso de erro, exibe mensagem de alerta
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

  ##
  # Realiza o logout do usuário.
  # DELETE /logout
  # Remove o usuário da sessão e redireciona para a tela de login.
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

