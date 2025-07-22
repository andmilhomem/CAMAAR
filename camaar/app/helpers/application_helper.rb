module ApplicationHelper
  # Retorna o nome amigável da página, com base no request.path
  def nome_da_pagina
    case request.path
    when admin_path
      "Gerenciamento"
    when login_path
      "Login"
    when redefinir_senha_path
      "Redefinição de senha"
    when formularios_path
      "Avaliações"
    when resposta_formularios_path
      "Gerenciamento - Resultados"
    when templates_path
      "Gerenciamento - Templates"
    when root_path
      "Avaliações"
    when new_resposta_formulario_path
      "Avaliações"
    when resposta_formularios_path
      "Gerenciamento - Resultados"
    when %r{\A/templates/\d+/edit} 
      "Gerenciamento - Templates"
    when new_template_path
      "Gerenciamento - Templates"
    when new_formulario_path
      "Gerenciamento - Avaliações"
    else
      "CAMAAR"
    end
  end
end