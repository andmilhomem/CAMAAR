##
# Controller responsável pela redefinição de senhas dos usuários.
#
# Permite que o usuário redefina sua senha através de um token enviado por e-mail ou pelo usuário logado.
#
# Métodos principais:
# - edit: Exibe o formulário para redefinir a senha
# - update: Salva a nova senha
class SenhasController < ApplicationController
  skip_before_action :requerer_login, only: [:edit, :update]
  skip_before_action :requerer_usuario_ativo, only: [:edit, :update]

  before_action :set_usuario, only: [:edit, :update]
  
  ##
  # Exibe o formulário para redefinir a senha do usuário.
  # GET /senha/edit?token=...
  def edit

  end

  ##
  # Salva a nova senha do usuário.
  # PATCH /senha
  # Parâmetros:
  # - password: Nova senha
  # - password_confirmation: Confirmação da nova senha
  #
  # O usuário é encontrado pelo token ou pelo usuário logado.
  # Após atualizar, redireciona para o login com mensagem de sucesso.
  def update
    # O @usuario é encontrado pelo before_action :set_usuario
    if @usuario.update(password_params)
      # Após redefinir, faz o login do usuário para uma experiência mais fluida

      redirect_to login_path, notice: "Sua senha foi atualizada com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  ##
  # Busca o usuário para redefinição de senha.
  # Tenta encontrar pelo token do e-mail ou pelo usuário logado.
  # Se não encontrar, bloqueia o acesso.
  def set_usuario
    # Tenta encontrar o usuário pelo token do e-mail
    @usuario = Usuario.find_signed(params[:token], purpose: "password_reset") if params[:token]
    # Se não houver token, tenta encontrar pelo usuário já logado (caso da senha temporária)
    @usuario ||= usuario_atual

    # Se não encontrou usuário de nenhuma forma, bloqueia o acesso
    redirect_to login_path, alert: "Acesso não autorizado." unless @usuario
  end

  ##
  # Parâmetros permitidos para atualização de senha.
  # Garante que a flag de senha temporária seja desativada.
  def password_params
    # Atualiza a senha e garante que a flag de senha temporária seja desativada
    params.require(:usuario).permit(:password, :password_confirmation).merge(esta_ativo: true)
  end
end