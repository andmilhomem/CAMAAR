module NavigationHelpers
  # Método que mapeia nomes de páginas às rotas correspondentes.
  # Método invocado pelos step definitions.

  # Exemplo de definição do livro SaaS.
  # Temos que adaptar do inglês para o português

  def path_to(page_name)
    case page_name

    when "Gerenciamento" then admin_path
    when "Login" then login_path
    when "Redefinição de senha" then redefinir_senha_path
    when "Avaliações" then formularios_path
    when "Gerenciamento - Resultados" then resposta_formularios_path
    when "Gerenciamento - Templates" then templates_path

    else
      raise "Não foi possível mapear a página \"#{page_name}\" a um caminho. Altere o arquivo features/support/paths.rb!\n"
    end
  end

end

World(NavigationHelpers)
