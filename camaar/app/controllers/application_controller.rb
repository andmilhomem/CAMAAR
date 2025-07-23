# Fornece métodos genéricos empregados em todos os controladores.
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :requerer_login
  before_action :requerer_usuario_ativo

  helper_method :usuario_atual, :usuario_logado?

  private

  # Determina qual é o usuário atual.
  # @param session[:usuario_id] [Integer] ID do usuário atual
  # @return @usuario_atual [Usuario] Usuário atual
  # @note Não produz efeitos colaterais.
  def usuario_atual
    @usuario_atual ||= Usuario.find_by(id: session[:usuario_id])
  end

  # Verifica se há usuário logado.
  # @param usuario_atual [Usuario] Usuário atual
  # @return [Boolean] Retorna true (se há usuário atual) ou false (caso contrário)
  # @note Não produz efeitos colaterais.
  def usuario_logado?
    usuario_atual.present?
  end

  # Impede acesso de terceiros a áreas restritas a usuários logados
  # @param usuario_logado [Boolean] Valor retornado por método que checa se há usuário logado
  # @note Não retorna valores, mas, quando não há usuário logado, produz como efeito colateral:
  #   1. redirecionamento para tela de login;
  #   2. apresentação de mensagem sobre exigência de login.
  def requerer_login
    return if usuario_logado?
    flash[:alert] = "Você precisa estar logado!" unless request.path == "/"
    redirect_to login_path
  end

  # Impede acesso de terceiros a áreas restritas a usuários com senha definitiva
  # @param usuario_atual [Usuario] Usuário atual
  # @note Não retorna valores, mas, quando não há usuário com senha definitiva, produz como efeito colateral:
  #   1. redirecionamento para tela de redefinição de senha;
  #   2. apresentação de mensagem sobre redefinição de senha.
  def requerer_usuario_ativo
    if usuario_atual && !usuario_atual.esta_ativo
      redirect_to redefinir_senha_path, alert: "Você precisa redefinir sua senha!"
    end
  end

  # Impede acesso de terceiros a áreas restritas a usuários com perfil de administrador
  # @param usuario_atual [Usuario] Usuário atual
  # @note Não retorna valores, mas, quando não há usuário com perfil de administrador, produz como efeito colateral:
  #   1. redirecionamento para tela inicial;
  #   2. apresentação de mensagem sobre restrição de acesso.
  def requerer_admin
    unless usuario_atual&.e_admin
      redirect_to root_path, alert: "Acesso restrito a administradores!"
    end
  end
end