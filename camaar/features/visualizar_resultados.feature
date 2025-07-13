# language: pt

Funcionalidade: Visualização de resultados dos formulários
    Eu como Administrador
    Quero visualizar os formulários criados
    A fim de poder gerar um relatório a partir das respostas
    
    Contexto:
        Dado que estou logado como administrador
        E que estou na página "Gerenciamento"

    Cenário: Formulários respondidos
        Dado que foi criado um formulário para a turma "BANCO DE DADOS"
        E que o formulário da turma "BANCO DE DADOS" já recebeu respostas
        Quando clico no botão "Resultados"
        Então devo ir para a página "Gerenciamento - Resultados"
        E devo ver o formulário da turma "BANCO DE DADOS"

    Cenário: Nenhum formulário respondido
        Dado que nenhum formulário foi respondido
        Quando clico no botão "Resultados"
        Então devo ir para a página "Gerenciamento - Resultados"
        E devo ver a mensagem "Nenhum formulário respondido!"