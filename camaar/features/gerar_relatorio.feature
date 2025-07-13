# language: pt

Funcionalidade: Gerar relatório do administrador
    Eu como Administrador
    Quero baixar um arquivo csv contendo os resultados de um formulário
    A fim de avaliar o desempenho das turmas

    Contexto:
        Dado que estou logado como administrador
        E que foi criado um formulário para a turma "BANCO DE DADOS"
    
    Cenário: Formulário possui respostas
        Dado que o formulário da turma "BANCO DE DADOS" já recebeu respostas
        E que estou na página "Gerenciamento - Resultados"
        Quando clico no card do formulário da turma "BANCO DE DADOS"
        Então devo requisitar o download do arquivo CSV correspondente