# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Verifica se já existe um usuário admin com o email
unless Usuario.exists?(email: 'mandelli@unb.br')
  # Criação do usuário admin
  usuario = Usuario.new(
    nome: 'MARCELO MANDELLI',
    formacao: 'DOUTORADO',
    ocupacao: 'docente',
    num_usuario: 83807519422,
    email: 'mandelli@unb.br',
    e_admin: true,
    esta_ativo: true,
    password_digest: BCrypt::Password.create(ENV.fetch('SENHA_ADMIN_CAMAAR', '1$senhaADMIN')),
    departamento: 'DEPTO CIÊNCIAS DA COMPUTAÇÃO'
  )

  if usuario.save
    puts "Usuário admin criado com sucesso!"
  else
    puts "Falha ao criar o usuário admin: #{usuario.errors.full_messages.join(', ')}"
  end
else
  puts "Usuário admin já existe."
end

# Criação de templates de exemplo
exemplos = [
  { nome: 'Avaliação Docente 2024.1', data_versao: Time.now },
  { nome: 'Feedback de Curso - Computação', data_versao: Time.now - 1.day },
  { nome: 'Pesquisa de Satisfação', data_versao: Time.now - 2.days }
]

exemplos.each do |attrs|
  Template.find_or_create_by!(nome: attrs[:nome]) do |t|
    t.data_versao = attrs[:data_versao]
  end
end

# Criação de template para testes cucumber
unless Template.exists?(nome: 'Formulário de opinião')
  template = Template.create!(nome: 'Formulário de opinião')
  template.questaos.create!(num_questao: 1, tipo: 'Texto', enunciado: 'O que você achou da disciplina?')
  template.questaos.create!(num_questao: 2, tipo: 'Texto', enunciado: 'Sugestões para o professor')
end

puts 'Templates de exemplo criados!'