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

## Papéis
Na primeira parte da Sprint 1 (cenários BDD), o papel de Scrum Master ficou ocasionalmente a cargo de André, mas não houve definição de Product Owner: cada integrante ficou responsável por um grupo de histórias de usuário e, assim, pelos requisitos a elas correspondentes. Na segunda parte da Sprint 1 (modelo entidade-relacionamento), manteve-se a mesma dinâmica.

## Funcionalidades
As funcionalidades que serão desenvolvidas no projeto correspondem a histórias de usuário especificadas nas issues do repositório original (https://github.com/EngSwCIC/CAMAAR/issues). Abaixo, listam-se as histórias que serão implementadas, com uma breve descrição e a indicação do integrante responsável e do esforço necessário.

| Issue | Descrição                                     | Responsável | Esforço |
|-------|-----------------------------------------------|-------------|---------|
|  098  | Importar dados do SIGAA                       | André       | 3       |
|  099  | Responder formulário                          | Aquila      | 4       |
|  100  | Cadastrar usuários do sistema                 | André       | 3       |
|  101  | Gerar relatório do administrador              | Paulo       | 3       |
|  102  | Criar template de formulário                  | Mikhael     | 8       |
|  103  | Criar formulário de avaliação                 | Paulo       | 8       |
|  104  | Sistema de login                              | Matheus     | 5       |
|  105  | Sistema de definição de senha                 | Matheus     | 5       |
|  108  | Atualizar base de dados com os dados do SIGAA | André       | 2       |
|  109  | Visualização de formulários para responder    | Aquila      | 3       |
|  110  | Visualização de resultados dos formulários    | Paulo       | 5       |
|  111  | Visualização dos templates criados            | Mikhael     | 3       |
|  112  | Edição e deleção de templates                 | Mikhael     | 5       |

## Política de branching
A cada sprint será criada uma branch (ex.: sprint-1). Para cada funcionalidade ou tarefa relevante a ser desenvolvida na sprint será criada uma branch específica (ex.: estrutura-projeto, cenarios-bdd) que, quando concluída, será fundida (merge) com a branch da sprint. Ao final da sprint, será feito pull request da branch da sprint para a branch main do repositório original.

## Histórico de atividades
### Sprint 1 - Parte 1 (Cenários BDD)
Na parte 1 da sprint 1, criou-se o código correspondente à estrutura básica do projeto Rails. As histórias de usuário (acima detalhadas) foram divididas entre os integrantes do grupo para que cada um, utilizando a ferramenta Miro (https://miro.com/app/board/uXjVIoZZ5ic=/), especificasse cenários BDD para as histórias sob sua responsabilidade. Em 20/06/2025, entre 16h e 18h, realizou-se reunião entre os integrantes do grupo para discutir as histórias de usuário e aperfeiçoar os cenários BDD desenvolvidos. Na reunião foi definido o esforço necessário à implementação de cada história de usuário, de acordo com a escala Fibonacci (1, 2, 3, 5, 8, 13). Por fim, os cenários BDD foram incorporados ao código do projeto (camaar/features). 

### Sprint 1 - Parte 2 (Modelo Entidade-Relacionamento)
Na parte 2 da sprint 1, com base nos dados (JSONs) e histórias de usuário disponibilizados no repositório original do projeto, elaborou-se uma versão preliminar de modelo entidade-relacionamento utilizando-se a ferramenta draw.io (https://tinyurl.com/4teu37n3). Em 23/06/2025, entre 21h e 21h30, realizou-se reunião entre os integrantes do grupo para discutir e aperfeiçoar esse modelo. Após a reunião e consultas ao monitor da disciplina, foram feitos ajustes no modelo e foi escrito o relatório descritivo do modelo (arquivo CAMAAR_MER, disponível no diretório principal deste repositório).