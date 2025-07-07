class SessoesController < ApplicationController
  skip_before_action :requerer_login, only: [:new, :create, :login_para_teste]
  skip_before_action :requerer_usuario_ativo, only: [:new, :create, :login_para_teste]

  def new
  end

  def create

  # Implementação temporária apenas para viabilizar uso da interface.
  # Os testes (do Cucumber e do RSpec) não dependem desse trecho.
    usuario = Usuario.find_by(email: params[:email])

    if usuario
      session[:usuario_id] = usuario.id
      redirect_to root_path, notice: "Login realizado com sucesso!"
    else
      puts "ERRO NO LOGIN DE TESTE"
      redirect_to login_path, alert: "Usuário não encontrado"
    end  
  end

  def destroy
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
