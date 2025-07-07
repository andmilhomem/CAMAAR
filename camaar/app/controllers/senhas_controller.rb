
class SenhasController < ApplicationController
  skip_before_action :requerer_login, only: [:new, :create]

  before_action :set_usuario, only: [:edit, :update]

  def new
  end

  def create
    @usuario = Usuario.find_by(email: params[:email])
    if @usuario.present?
      PasswordMailer.with(usuario: @usuario).reset.deliver_later
    end
    redirect_to root_path, notice: "Se o e-mail existir em nossa base, um link de redefinição foi enviado."
  end

  
  def edit
    
  end

  # Salva a nova senha
  def update
    # O @usuario é encontrado pelo before_action :set_usuario
    if @usuario.update(password_params)
      # Após redefinir, faz o login do usuário para uma experiência mais fluida
      session[:usuario_id] = @usuario.id
      redirect_to login_path, notice: "Sua senha foi atualizada com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_usuario
    # Tenta encontrar o usuário pelo token do e-mail
    @usuario = Usuario.find_signed(params[:token], purpose: "password_reset") if params[:token]
    # Se não houver token, tenta encontrar pelo usuário já logado (caso da senha temporária)
    @usuario ||= usuario_atual

    # Se não encontrou usuário de nenhuma forma, bloqueia o acesso
    redirect_to login_path, alert: "Acesso não autorizado." unless @usuario
  end

  def password_params
    # Atualiza a senha e garante que a flag de senha temporária seja desativada
    params.require(:usuario).permit(:password, :password_confirmation).merge(esta_ativo: true)
  end
end