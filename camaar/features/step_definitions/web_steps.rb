require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Dado("que estou logado como administrador") do
  @admin = Usuario.create!(
    nome: 'José da Silva',
    formacao: 'DOUTORADO',
    ocupacao: 'docente',
    num_usuario: 98293482391,
    email: 'admin@example.com',
    e_admin: true,
    esta_ativo: true,
    password: 'M1nha$enha',
    password_confirmation: 'M1nha$enha'
  )
  page.set_rack_session(usuario_id: @admin.id)
end

Dado("que estou logado como participante") do
  @participante = Usuario.create!(
    nome: 'João Alves',
    matricula: 202033447,
    formacao: 'graduando',
    ocupacao: 'discente',
    num_usuario: 202033447,
    email: 'joaoalves@aluno.unb.br',
    e_admin: false,
    esta_ativo: true,
    password: 'M1nha$enha',
    password_confirmation: 'M1nha$enha'
  )
  page.set_rack_session(usuario_id: @participante.id)
end

Dado("que estou logado como novo usuário") do
  @participante = Usuario.create!(
    nome: 'João Alves',
    matricula: 202033447,
    formacao: 'graduando',
    ocupacao: 'discente',
    num_usuario: 202033447,
    email: 'joaoalves@aluno.unb.br',
    e_admin: false,
    esta_ativo: false,
    password: 'M1nha$enha',
    password_confirmation: 'M1nha$enha'
  )
  page.set_rack_session(usuario_id: @participante.id)
end

Dado("que estou na página {string}") do |nome_pagina|
  visit path_to(nome_pagina)
end

Quando("preencho o campo {string} com o valor {string}") do |nome_campo, valor|
  fill_in nome_campo, with: valor
end

Quando("preencho o campo {string} dentro de {string} com o valor {string}") do |nome_campo, nome_conteiner, valor|
  within("[data-nome='#{nome_conteiner}']") do
    fill_in nome_campo, with: valor
  end
end

Quando("informo o valor {string} dentro de {string}") do |valor, nome_conteiner|
  within("[data-nome='#{nome_conteiner}']") do
    campo = find("textarea, input[type='text']", match: :first)
    campo.fill_in with: valor
  end
end

Quando("seleciono a opção {string} dentro de {string}") do |nome_opcao, nome_conteiner|
  within("[data-nome='#{nome_conteiner}']") do
    choose(nome_opcao)
  end
end

Quando("clico no botão {string} dentro do template {string}") do |nome_botao, nome_template|
  within("[data-nome='#{nome_template}']") do
    if nome_botao == "Editar template"
      click_link("✏️")
    elsif nome_botao == "Deletar template"
      click_button("🗑️")
    else
      click_button(nome_botao)
    end
  end
end

Quando('clico no card do formulário da turma {string}') do |nome_disciplina|
  find("a[data-nome='#{nome_disciplina}']").click
end

Quando('clico no formulário da turma {string}') do |nome_disciplina|
  within("[data-nome='#{nome_disciplina}']") do
    click_link
  end
end

Quando("apago o conteúdo do campo {string}") do |nome_campo|
  fill_in nome_campo, with: ""
end

Então("devo permanecer na página {string}") do |nome_pagina|
  expect(current_path).to eq path_to(nome_pagina)
end

Então("devo ir para a página {string}") do |nome_pagina|
  expect(page).to have_current_path(path_to(nome_pagina), ignore_query: true)
end

Então("devo ir para a página inicial") do
  expect(page).to have_current_path("/")
end

Quando("clico no botão {string}") do |nome_botao|
  click_on(nome_botao)
end

Quando('seleciono a opção {string} na caixa {string}') do |opcao, nome_caixa|
  select opcao, from: nome_caixa
end

Quando('seleciono a opção {string} na caixa {string} dentro de {string}') do |opcao, nome_caixa, nome_conteiner|
  within("[data-nome='#{nome_conteiner}']") do
    select opcao, from: nome_caixa
  end
end

Quando("seleciono a opção de turma {string}") do |turma|
  linha = find("table").all("tr").find do |tr|
    tr.has_text?(turma)
  end
  checkbox = linha.find("input[type='checkbox']", visible: :all)
  checkbox.check
end

Quando("vejo a mensagem {string}") do |mensagem|
 # expect(page).to have_selector("#modal-confirmacao", visible: true)
  expect(page).to have_content(mensagem)
end

Então("devo ver a mensagem {string}") do |mensagem|
  expect(page).to have_content(mensagem)
end

Então("devo ver o formulário da turma {string}") do |nome_turma|
  expect(page).to have_content(nome_turma)
end

Então("devo ver o template {string}") do |nome_template|
  expect(page).to have_content(nome_template)
end

Então("não devo mais ver o template {string}") do |nome_template|
  expect(page).not_to have_content(nome_template)
end

Então("não devo ver nenhum template") do
  expect(page).not_to have_link("✏️")
  expect(page).not_to have_button("🗑️")
end

Então('devo ver o botão {string}') do |nome_botao|
  if nome_botao == "Editar template"
    expect(page).to have_link("✏️")
  elsif nome_botao == "Deletar template"
    expect(page).to have_button("🗑️")
  else
    expect(page).to have_button(nome_botao)
  end
end

Quando("clico no link de redefinição de senha recebido por e-mail") do
  usuario = Usuario.create!(
    nome: 'João Alves',
    matricula: 202033447,
    formacao: 'graduando',
    ocupacao: 'discente',
    num_usuario: 202033447,
    email: 'joaoalves@aluno.unb.br',
    e_admin: false,
    esta_ativo: false,
    password: 'M1nha$enha',
    password_confirmation: 'M1nha$enha'
  )
  token = usuario.signed_id(purpose: "password_reset", expires_in: 60.minutes)
  visit redefinir_senha_path(token: token) 
end

Quando("preencho o campo \"Email\" com um e-mail de usuário novo") do
  @email = 'joaoalves@aluno.unb.br'
  @senha = 'M1nha$enha'
  
  @usuario = Usuario.create!(
    nome: 'João Alves',
    matricula: 202033447,
    formacao: 'graduando',
    ocupacao: 'discente',
    num_usuario: 202033447,
    email: @email,
    e_admin: false,
    esta_ativo: false,
    password: @senha,
    password_confirmation: @senha
  )
  fill_in "Email", with: @email
end

Quando("preencho o campo \"Email\" com um e-mail correspondente a um usuário cadastrado") do
  @email = 'joaoalves@aluno.unb.br'
  @senha = 'M1nha$enha'
  
  @usuario = Usuario.create!(
    nome: 'João Alves',
    matricula: 202033447,
    formacao: 'graduando',
    ocupacao: 'discente',
    num_usuario: 202033447,
    email: @email,
    e_admin: false,
    esta_ativo: true,
    password: @senha,
    password_confirmation: @senha
  )
  fill_in "Email", with: @email    
end

Quando("preencho o campo \"Email\" com um e-mail não correspondente a um usuário cadastrado") do
  email = "esse_email@nao.existe"
  expect(Usuario.exists?(email: email)).to be false
  fill_in "Email", with: email   
end

Quando("preencho o campo \"Senha\" com a senha correspondente a esse usuário") do
  fill_in "Senha", with: @senha
end

Quando("preencho o campo \"Senha\" com qualquer valor") do
  fill_in "Senha", with: "qualquervalor"
end

Quando("preencho o campo \"Senha\" com senha não correspondente a esse usuário") do
  fill_in "Senha", with: "nao_e_a_senha"
end

Dado("que já existem turmas, matérias e participantes cadastrados") do
  @usuario = Usuario.create!(
  nome: 'João Alves',
  matricula: 202033447,
  formacao: 'graduando',
  ocupacao: 'discente',
  num_usuario: 202033447,
  email: 'joaoalves@aluno.unb.br',
  e_admin: false,
  esta_ativo: true,
  password: 'M1nha$enha',
  password_confirmation: 'M1nha$enha'
  )
  
  @disciplina = Disciplina.create!(
  codigo: "CIC0012",
  nome: "COMPUTAÇÃO QUÂNTICA"
  )

  @turma = Turma.create!(
  codigo: "TA",
  semestre: "2021.2",
  horario: "35T45",
  disciplina: @disciplina
  )

  ImportacaoDado.create!(usuario: @admin)
end

Dado("que existe uma turma \"BANCO DE DADOS\"") do
  @disciplina = Disciplina.create!(
  codigo: "CIC0097",
  nome: "BANCO DE DADOS"
  )

  @turma = Turma.create!(
  codigo: "TA",
  semestre: "2021.2",
  horario: "35T45",
  disciplina: @disciplina
  )  

end

Dado("que existe um template \"Avaliação Discente 1\"") do
  Template.create!(
  nome: "Avaliação Discente 1",
  data_versao: Time.current
  )
end

Dado("que não existem templates cadastrados") do
  Template.destroy_all 
end

Dado("que não existem turmas cadastradas") do
  Turma.destroy_all
end

Dado("que existe um template previamente criado com o nome \"Formulário de opinião\"") do
  # Limpar templates existentes com o mesmo nome para evitar conflitos
  Template.where(nome: "Formulário de opinião").destroy_all
  
  @template = Template.create!(
    nome: "Formulário de opinião",
    data_versao: Time.current
  ) 

  Questao.create!(
    num_questao: 1,
    tipo: "Texto",
    enunciado: "Qual sua linguagem favorita?",
    template: @template
  )
  
  # Verificar se o template foi criado corretamente
  expect(@template).to be_persisted
  expect(@template.nome).to eq("Formulário de opinião")
  expect(Template.find_by(nome: "Formulário de opinião")).to be_present
end

Dado("que foi criado um formulário para a turma \"BANCO DE DADOS\"") do
  step "que existe uma turma \"BANCO DE DADOS\""
  step "que existe um template previamente criado com o nome \"Formulário de opinião\""
  @formulario = Formulario.create!(
  data_criacao: Time.current,
  turma: @turma
  )
end

Dado("que o formulário da turma \"BANCO DE DADOS\" já recebeu respostas") do
  RespostaFormulario.create!(
  data_resposta: Time.current,
  formulario: @formulario
  )
end

Dado("que nenhum formulário foi respondido") do
    RespostaFormulario.destroy_all
end

Então("devo requisitar o download do arquivo CSV correspondente") do
  expect(page).to have_link(nil, href: resposta_formularios_path(form_id: @formulario.id))
end

Dado("que o formulário da turma \"BANCO DE DADOS\" ainda não recebeu respostas") do
  disciplina = Disciplina.find_by(nome: "BANCO DE DADOS")
  turmas = Turma.where(disciplina: disciplina)
  formularios = Formulario.where(turma: turmas)
  RespostaFormulario.where(formulario: formularios).destroy_all
end

Dado("que ainda não existem turmas, matérias e participantes cadastrados") do
  ImportacaoDado.exists?
end

Dado("que os dados estão disponíveis para importação") do
  base_path = Rails.root.join("..")
  arquivos_esperados = [
    base_path.join("class_members.json"),
    base_path.join("classes.json")
  ]
  arquivos_esperados.each do |arquivo|
    unless File.exist?(arquivo)
      raise "Arquivo esperado não encontrado: #{arquivo}"
    end
  end
end

Dado("que os dados não estão disponíveis para importação") do
    @stub = allow(File).to receive(:exist?).and_return(false)
end

Dado("que estou matriculado na turma \"BANCO DE DADOS\"") do
    step "que existe uma turma \"BANCO DE DADOS\""
    @participante.turmas << @turma unless @participante.turmas.include?(@turma)
end
    
Dado("que existe um formulário não respondido na turma \"BANCO DE DADOS\" com uma questão do tipo \"Texto\" e outra do tipo \"Radio\" com duas opções, \"Sim\" e \"Não\"") do
  @template = Template.create!(
  nome: "Autoavaliação",
  data_versao: Time.current
  )

  @formulario = Formulario.create!(
  data_criacao: Time.current,
  turma: @turma
  )

  @questao1 = Questao.create!(
  num_questao: 1,
  tipo: "Texto",
  enunciado: "Quem é você?",
  template: @template,
  formulario: @formulario
  )

  @questao2 = Questao.create!(
  num_questao: 2,
  tipo: "Radio",
  enunciado: "Você tem certeza?",
  template: @template,
  formulario: @formulario
  )

  Opcao.create!(
  num_opcao: 1,
  texto_opcao: "Sim",
  questao: @questao2
  )

  Opcao.create!(
  num_opcao: 2,
  texto_opcao: "Não",
  questao: @questao2
  )
  
  @participante.formularios
  .where(turma: @turma)
  .each { |formulario| @participante.formularios.delete(formulario) }
end

Dado("que existe um formulário não respondido na turma \"BANCO DE DADOS\"") do
  @formulario = Formulario.create!(
  data_criacao: Time.current,
  turma: @turma
  )
  
  @participante.formularios
  .where(turma: @turma)
  .each { |formulario| @participante.formularios.delete(formulario) }
end

Dado("que existe apenas o formulário da turma \"BANCO DE DADOS\", já respondido") do
  Formulario.destroy_all

  @formulario = Formulario.create!(
  data_criacao: Time.current,
  turma: @turma
  )

  @participante.formularios << @formulario unless @participante.formularios.include?(@formulario)
end

Dado("que não existem formulários cadastrados") do
    Formulario.destroy_all
end

Dado("que existem templates previamente criados com os nomes \"Avaliação discente 1\" e \"Avaliação docente 1\"") do
  # Limpar templates existentes para evitar conflitos
  Template.where(nome: ["Avaliação discente 1", "Avaliação docente 1"]).delete_all
  
  Template.create!(
    nome: "Avaliação discente 1",
    data_versao: Time.current
  )

  Template.create!(
    nome: "Avaliação docente 1",
    data_versao: Time.current
  )
  
  # Verificar se os templates foram criados corretamente
  expect(Template.find_by(nome: "Avaliação discente 1")).to be_present
  expect(Template.find_by(nome: "Avaliação docente 1")).to be_present
  
  # Se estivermos em uma página, recarregar para garantir que os templates apareçam
  if page.current_path.present?
    visit current_path
  end
end

Então("devo ver os templates \"Avaliação discente 1\" e \"Avaliação docente 1\"") do
  # Aguarda os templates aparecerem na página
  expect(page).to have_content("Avaliação discente 1")
  expect(page).to have_content("Avaliação docente 1")
  
  # Verifica se os templates estão visíveis como cards
  expect(page).to have_selector('.template-card', text: /Avaliação discente 1/)
  expect(page).to have_selector('.template-card', text: /Avaliação docente 1/)
end  

Dado("que não existe nenhum template previamente criado") do
    Template.destroy_all
end