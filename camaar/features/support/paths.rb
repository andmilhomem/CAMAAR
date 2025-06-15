module NavigationHelpers
  # Método que mapeia nomes de páginas às rotas correspondentes.
  # Método invocado pelos step definitions.

  # Exemplo de definição do livro SaaS.
  # Temos que adaptar do inglês para o português

  def path_to(page_name)
    case page_name

    when /^the (RottenPotatoes )?home\s?page$/ then '/movies'
    when /^the movies page$/ then '/movies'

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = ::Regexp.last_match(1).split(/\s+/)
        send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" \
              "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
