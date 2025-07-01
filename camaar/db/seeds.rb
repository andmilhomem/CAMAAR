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