# language: pt

Funcionalidade: Visualização de resultados dos formulários
    Eu como Administrador
    Quero visualizar os formulários criados
    A fim de poder gerar um relatório a partir das respostas
    
    Contexto:
        Dado que estou logado como administrador
        E que estou na página "Gerenciamento"
        Quando clico no botão "Resultados"

    Cenário: Formulários cadastrados
        Dado que foi criado um formulário para a turma "BANCO DE DADOS"
        Então devo ver o formulário da turma "BANCO DE DADOS"

    Cenário: Nenhum formulário cadastrado
        Dado que não existem formulários cadastrados
        Então devo ver a mensagem "Nenhum formulário cadastrado!"