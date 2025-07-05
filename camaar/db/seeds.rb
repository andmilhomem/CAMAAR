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

# dados de teste para formulario
# 0) template padrao
tm = Template.find_or_create_by!(nome: 'Template Padrao', data_versao: Date.current)
puts "Template: #{tm.id} (v#{tm.data_versao})"

# 1) usuario de teste
u = Usuario.find_or_initialize_by(email: 'teste@unb.br')
u.assign_attributes(
  nome:            'mandelli unb teste',
  formacao:        'graduacao',
  ocupacao:        'docente',
  num_usuario:     99_999_999_999,
  matricula:       '20250001',
  departamento:    'CIENCIAS DA COMPUTACAO',
  password_digest: BCrypt::Password.create('senha123'),
  esta_ativo:      true,
  e_admin:         false
)
u.save!(validate: false)
puts "usuario de teste: #{u.id}"

# 2) disciplina
d = Disciplina.find_or_create_by!(codigo: 'DISC-01') do |disc|
  disc.nome = 'Teste de Disciplina'
end

# 3) turma
t = Turma.find_or_create_by!(codigo: 'T1', semestre: '2025-1') do |turma|
  turma.horario    = 'Seg 10:00-12:00'
  turma.disciplina = d
end

# 4) associacao usuario turma
unless u.turmas.include?(t)
  u.turmas << t
end

# 5) formulario
f = Formulario.find_or_create_by!(turma: t) do |form|
  form.data_criacao = Time.current
end
puts "Formulario: #{f.id} (Turma #{t.codigo})"

# 6) questoes
q1 = Questao.find_or_create_by!(formulario: f, template: tm, num_questao: 1) do |q|
  q.tipo      = 'Texto'
  q.enunciado = 'Como voce avalia este teste?'
end

q2 = Questao.find_or_create_by!(formulario: f, template: tm, num_questao: 2) do |q|
  q.tipo      = 'Radio'
  q.enunciado = 'Voce gostou do formulario?'
end

# 7) opcoes de multipla escolha
[
  { questao: q2, num_opcao: 1, texto_opcao: 'Sim' },
  { questao: q2, num_opcao: 2, texto_opcao: 'Nao' }
].each do |attrs|
  Opcao.find_or_create_by!(attrs)
end

# adiciona mais 5 formularios pra responder

# carregue as instancias de turma e template
turma    = Turma.first
template = Template.first

# crie 5 formularios com 2 questoes cada
5.times do |i|
  formulario = Formulario.create!(
    turma:        turma,
    data_criacao: Time.current + i.days
  )

  # questao de texto
  Questao.create!(
    formulario:  formulario,
    template:    template,
    num_questao: 1,
    tipo:        'Texto',
    enunciado:   "pergunta aberta #{i + 1}"
  )

  # questao de radio
  questao_radio = Questao.create!(
    formulario:  formulario,
    template:    template,
    num_questao: 2,
    tipo:        'Radio',
    enunciado:   "pergunta multipla #{i + 1}"
  )

  # opcoes para a questao de radio
  %w[opcao_a opcao_b].each_with_index do |texto, idx|
    Opcao.create!(
      questao:    questao_radio,
      num_opcao:  idx + 1,
      texto_opcao: texto
    )
  end

  puts "formulario ##{formulario.id} criado com 2 questoes"
end

# exiba quantos formularios existem na turma
total = Formulario.where(turma: turma).count
puts "total de formularios na turma #{turma.id}: #{total}"

puts 'fluxo de seed para formularios carregado com sucesso'
