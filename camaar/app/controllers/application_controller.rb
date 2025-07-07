class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :requerer_login
  #before_action :requerer_usuario_ativo

  helper_method :usuario_atual, :usuario_logado?

  private

  def usuario_atual
    @usuario_atual ||= Usuario.find_by(id: session[:usuario_id])
  end

  def usuario_logado?
    usuario_atual.present?
  end

  def requerer_login
    redirect_to login_path, alert: "Você precisa estar logado!" unless usuario_logado?
  end

  def requerer_usuario_ativo
    if usuario_atual && !usuario_atual.esta_ativo
      redirect_to nova_senha_path, alert: "Você precisa redefinir sua senha!"
    end
  end

  def requerer_admin
    unless usuario_atual&.e_admin
      redirect_to root_path, alert: "Acesso restrito a administradores!"
    end
  end
end