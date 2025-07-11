# language: pt

Funcionalidade: Visualização de templates criados
    Eu como Administrador
    Quero visualizar os templates criados
    A fim de poder editar e/ou deletar um template que eu criei    
    
    Contexto:
        Dado que estou logado como administrador
        E que estou na página "Gerenciamento - Templates"

    Cenário: Exibir templates existentes
        Dado que existem templates previamente criados com os nomes "Avaliação discente 1" e "Avaliação docente 1"
        E que estou na página "Gerenciamento - Templates"
        Então devo ver os templates "Avaliação discente 1" e "Avaliação docente 1"
        E devo ver o botão "Editar template"
        E devo ver o botão "Deletar template"

    Cenário: Nenhum template criado
        Dado que não existe nenhum template previamente criado
        E que estou na página "Gerenciamento - Templates"
        Então não devo ver nenhum template
        Mas devo ver o botão "Adicionar template"