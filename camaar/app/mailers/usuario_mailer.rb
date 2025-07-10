class UsuarioMailer < ApplicationMailer
  def enviar_senha
    @usuario = params[:usuario]
    @senha_padrao = params[:senha_padrao]
    @token = params[:token]
    mail(to: @usuario.email, subject: "CAMAAR - Senha provisória")
  end
end