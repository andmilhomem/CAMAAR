# language: pt

Funcionalidade: Criar formulário de avaliação
    Eu como Administrador
    Quero criar um formulário baseado em um template para as turmas que eu escolher
    A fim de avaliar o desempenho das turmas no semestre atual

    Contexto:
        Dado que estou logado como administrador

    Cenário: Templates e turmas disponíveis e selecionados
        Dado que existe uma turma "BANCO DE DADOS"
        E que existe um template "Avaliação Discente 1"
        E que estou na página "Gerenciamento"
        Quando clico no botão "Enviar Formulários"
        E seleciono a opção "Avaliação Discente 1" na caixa "Template"
        E seleciono a opção de turma "BANCO DE DADOS"
        E clico no botão "Enviar"
        Então devo ver a mensagem "Formulário(s) criado(s) com sucesso!"


    Cenário: Templates e turmas disponíveis e informações incompletas
        Dado que existe uma turma "BANCO DE DADOS"
        E que existe um template "Avaliação Discente 1"
        E que estou na página "Gerenciamento"
        Quando clico no botão "Enviar Formulários"
        E seleciono a opção "Avaliação Discente 1" na caixa "Template"
        E clico no botão "Enviar"
        Então devo ver a mensagem "Preencha todas as informações necessárias!"

    Cenário: Nenhum template cadastrado
        Dado que não existem templates cadastrados
        E que estou na página "Gerenciamento"
        Então devo ver a mensagem "Nenhum template disponível!"

    Cenário: Nenhuma turma cadastrada
        Dado que não existem turmas cadastradas
        E que estou na página "Gerenciamento"
        Então devo ver a mensagem "Nenhuma turma disponível!"