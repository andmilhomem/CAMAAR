# CAMAAR
Sistema para avaliação de atividades acadêmicas remotas do CIC

## Apresentação
Trata-se de projeto de desenvolvimento de software realizado no contexto da disciplina Engenharia de Software do Departamento de Ciência da Computação da Universidade de Brasília (UnB) no primeiro semestre de 2025. O software a ser desenvolvido consiste em um sistema para avaliação de atividades acadêmicas e teve seus requisitos definidos no repositório original https://github.com/EngSwCIC/CAMAAR.

## Identificação do grupo
* 202033427 - André Milhomem Araújo de Godoi (andmilhomem)
* 202021800 - Aquila Macedo Costa (aquilamacedo)
* 222011599 - Matheus Chagas Lopes (metiosbr)
* 211010440 - Mikhael Ferreira Moreira (mikhaelfm)
* 200025937 - Paulo Maciel Torres Filho (paulomacieltorresfilho)

## Execução do projeto
O projeto foi desenvolvido utilizando a linguagem de programação Ruby 3.4.4 e o framework Rails 8.0.2. Para constituir o ambiente de desenvolvimento, devem ser executados os seguintes comandos (no diretório camaar):
* bundle install : instala as gems especificadas no arquivo Gemfile
* rails db:setup : cria o banco de dados; estrutura suas tabelas conforme especificações dos arquivos db/migrate/*.rb; popula a base com as seeds indicadas no arquivo db/seeds.rb
* rails s : inicia o servidor web da aplicação em ambiente local
* bundle exec cucumber : executa os testes do Cucumber (BDD)
* bundle exec rspec : executa os testes do RSpec (TDD)
Para viabilizar a realização de testes de interface, podem ser utilizados os seguintes perfis, especificados como seeds:

| Tipo                            | E-mail                  | Senha        |
|---------------------------------|-------------------------|--------------|
| Administrador                   | mandelli@unb.br         | 1$senhaADMIN |
| Ordinário com senha provisória  | aluno.teste@exemplo.com | Trocar@123   |
| Ordinário com senha definitiva  | teste@unb.br            | Senh@123     |

## Papéis
Nas Sprint 1 e 2, o papel de Scrum Master ficou a cargo de André e o papel de Product Owner sob responsabilidade de Paulo. Além disso, cada integrante ficou responsável por um grupo de histórias de usuário e, assim, pelos requisitos a elas correspondentes.

## Funcionalidades
As funcionalidades desenvolvidas no projeto correspondem a histórias de usuário especificadas nas issues do repositório original (https://github.com/EngSwCIC/CAMAAR/issues). Abaixo, listam-se as histórias planejadas, com uma breve descrição, a indicação do integrante responsável e do esforço necessário, bem como a numeração que a issue respectiva assumiu.

| Issue | Descrição                                            | Responsável | Esforço |
|-------|------------------------------------------------------|-------------|---------|
|  06   | Importar dados do SIGAA (#098)                       | André       |   3     |
|  07   | Responder formulário (#099)                          | Aquila      |   4     |
|  08   | Cadastrar usuários do sistema (#100)                 | André       |   3     |
|  09   | Gerar relatório do administrador (#101)              | Paulo       |   3     |
|  10   | Criar template de formulário (#102)                  | Mikhael     |   8     |
|  11   | Criar formulário de avaliação (#103)                 | Paulo       |   8     |
|  12   | Sistema de login (#104)                              | Matheus     |   5     |
|  13   | Sistema de definição de senha (#105)                 | Matheus     |   5     |
|  14   | Atualizar base de dados com os dados do SIGAA (#108) | André       |   2     |
|  15   | Visualização de formulários para responder (#109)    | Aquila      |   3     |
|  16   | Visualização de resultados dos formulários (#110)    | Paulo       |   5     |
|  17   | Visualização dos templates criados (#111)            | Mikhael     |   3     |
|  18   | Edição e deleção de templates (#112)                 | Mikhael     |   5     |

Ao final da Sprint-2, todas as issues foram resolvidas, à exceção da issue #11 (Criar formulário de avaliação), que será tratada na Sprint-3.

## Política de branching
Para cada sprint foi criada uma branch (sprint-1, sprint-2 e sprint-3). Para cada funcionalidade ou tarefa relevante desenvolvida na sprint foi criada uma branch específica (ex.: estrutura-projeto, cenarios-bdd). Para a implementação das histórias de usuário indicadas acima, foram criadas as seguintes branches: feature/dados (André - issues 6, 8 e 14), feature/login (Matheus - issues 12 e 13), feature/template (Mikhael - issues 10, 17 e 18), feature/formulario (Aquila - issues 7 e 15), feature/resposta (Paulo - issues 9, 11 e 16). Quando concluídas as tarefas relativas a determinada branch, ela foi fundida (merge) com a branch da sprint correspondente. Ao final de cada sprint, foi feito pull request da branch da sprint para a branch main do repositório original.

## Histórico de atividades
### Sprint 1 - Parte 1 (Cenários BDD)
Na parte 1 da sprint 1, criou-se o código correspondente à estrutura básica do projeto Rails. As histórias de usuário (acima detalhadas) foram divididas entre os integrantes do grupo para que cada um, utilizando a ferramenta Miro (https://miro.com/app/board/uXjVIoZZ5ic=/), especificasse cenários BDD para as histórias sob sua responsabilidade. Em 20/06/2025, entre 16h e 18h, realizou-se reunião entre os integrantes do grupo para discutir as histórias de usuário e aperfeiçoar os cenários BDD desenvolvidos. Na reunião foi definido o esforço necessário à implementação de cada história de usuário, de acordo com a escala Fibonacci (1, 2, 3, 5, 8, 13). Por fim, os cenários BDD foram incorporados ao código do projeto (camaar/features). 

### Sprint 1 - Parte 2 (Modelo Entidade-Relacionamento)
Na parte 2 da sprint 1, com base nos dados (JSONs) e histórias de usuário disponibilizados no repositório original do projeto, elaborou-se uma versão preliminar de modelo entidade-relacionamento utilizando-se a ferramenta draw.io (https://tinyurl.com/4teu37n3). Em 23/06/2025, entre 21h e 21h30, realizou-se reunião entre os integrantes do grupo para discutir e aperfeiçoar esse modelo. Após a reunião e consultas ao monitor da disciplina, foram feitos ajustes no modelo e foi escrito o relatório descritivo do modelo (arquivo CAMAAR_MER, disponível no diretório principal deste repositório).

### Sprint 2 - Implementação das histórias de usuário e testes (BDD e TDD)
Na sprint 2, foram implementadas as histórias de usuário descritas acima. Além disso, foram especificados (em features/step_definitios/web_steps.rb) os passos correspondentes aos 31 cenários de teste Cucumber (BDD) anteriormente definidos. Adicionalmente, na sprint-2 foram criados 46 testes RSpec (TDD), concomitantemente ao desenvolvimento. Para organizar o trabalho, criou-se um projeto no GitHub (https://github.com/users/andmilhomem/projects/3/views/1) e utilizou-se o Kanban como ferramenta de monitoramento da evolução das issues. Em 03/07/2025, entre 20h e 21h30, realizou-se reunião entre os integrantes do grupo para discutir a estrutura geral do projeto e decidir como cada um deveria integrar suas contribuições ao código. Após a reunião, cada integrante implementou o respectivo grupo de histórias de usuário (com os testes RSpec correspondentes) em branches específicas (feature/*). Por fim, essas branches foram revisadas e integradas à branch sprint-2. O resultado final é aprovado pela totalidade dos 46 testes RSpec e por 27 dos 31 testes Cucumber criados (falham apenas os testes relativos à issue #11, que será tratada na Sprint-3).

## Funcionalidades implementadas
Descrevem-se abaixo, a partir das rotas correpondentes, as principais funcionalidades da aplicação.

#### get /
Função - Processa requisição na raiz, direcionando à tela de login ou à tela de formulários pendentes, conforme se cuide de usuário autenticado ou não
Origem - Utilização do navegador pelo usuário

#### get /login (SessoesController#new)
Função - Apresenta tela de login, que exige e-mail e senha
Origem - Redirecionamento de qualquer requisição feita por usuário não autenticado

#### post /login (SessoesController#create)
Função - Cria sessão de usuário, em caso de autenticação bem-sucedida
Origem - Tela de login

#### delete /logout (SessoesController#destroy)
Função - Encerra sessão de usuário
Origem - Clique em botão de logout no menu superior

#### post /login_para_teste (SessoesControllet#login_para_teste)
Função - Permite criar sessão de usuário a partir do parâmetro e-mail, exclusivamente em ambiente de teste
Origem - Chamada em testes RSpec

#### get /senha/redefinir (SenhasController#edit)
Função - Apresenta tela de redefinição de senha
Origem - Tentativa de login de usuário com senha provisória ou utilização de link enviado por e-mail a usuário com senha provisória

####  patch /senha/redefinir (SenhasController#update)
Função - Atualiza senha do usuário, tornando-a definitiva
Origem - Tela de redefinição de senha

#### get /admin (AdminController#index)
Função - Apresenta as ações disponíveis aos usuários com perfil de administrador (importar dados; editar templates; enviar formulários; visualizar respostas de formulários)
Origem - Clique na opção "Gerenciamento" do menu lateral

#### post /admin/importar_dados (AdminController#importar_dados)
Função - Importa dados dos JSONs para o banco de dados e envia aos usuários criados e-mail com senha provisória e link com token para redefinição de senha
Origem - Tela de Gerenciamento

#### get /letter_opener (gem Letter Opener Web)
Função - Apresenta painel com e-mails enviados aos usuários criados
Origem - Utilização do navegador

#### get /formularios (FormulariosController#index)
Função - Apresenta todos os formulários não respondidos pelo usuário autenticado
Origem - Redirecionamento após autenticação de usuário ou utilização do menu superior

#### get /formularios/new (FormulariosController#new)
Função - Apresenta tela de envio de formulários para turmas
Origem - Tela de gerenciamento do administrador

#### post /formularios (FormulariosController#create)
Função - Envia formulário para turmas
Origem - Tela de envio de formulários do administrador 

#### get /resposta_formularios (RespostaFormulariosController#index)
Função - Apresenta todos os formulários que já foram respondidos ou, quando informado como parâmetro o número identificador de um formulário específico, gera um CSV com o conteúdo de todas as respostas correspondentes
Origem - Tela de gerenciamento do administrador ou, no caso do CSV, tela de resultados

#### get /resposta_formularios/new (RespostaFormulariosController#new)
Função - Apresenta tela de resposta a formulário
Origem - Tela de formulários pendentes de resposta do usuário

#### post /resposta_formularios (RespostaFormulariosController#create)
Função - Formaliza resposta a formulário
Origem - Tela de resposta a formulário

#### get /templates (TemplatesController#index)
Função - Apresenta todos os templates já criados
Origem - Tela de gerenciamento do administrador 

#### get /templates/new (TemplatesController#new)
Função - Apresenta formulário de criação de template
Origem - Tela de templates do administrador

#### post /templates (TemplatesController#create)
Função - Cria um template
Origem - Tela de criação de templates

#### get /templates/:id/edit (TemplatesController#edit)
Função - Apresenta tela de edição de template anteriomente criado
Origem - Tela de templates do administrador

#### patch /templates/:id (TemplatesController#update)
Função - Atualiza dados de um template editado
Origem - Tela de edição de templates

#### delete /templates/:id (TemplatesController#destroy)
Função - Apaga template da base de dados
Origem - Tela de templates do administrador