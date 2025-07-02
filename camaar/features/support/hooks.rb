# Reseta o ambiente antes de executar cada cenário

Before do
  # Reseta a sessão
  Capybara.reset_sessions!

  # Destroi entidades autônomas. As dependentes e associações serão deletadas automaticamente.
  Usuario.destroy_all
  Disciplina.destroy_all
  Template.destroy_all
end