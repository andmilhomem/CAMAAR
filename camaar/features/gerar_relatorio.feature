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
        Quando clico no formulário da turma "BANCO DE DADOS"
        Então deve se iniciar o download de um arquivo CSV
    
    Cenário: Formulário não possui respostas
        Dado que o formulário da turma "BANCO DE DADOS" ainda não recebeu respostas
        E que estou na página "Gerenciamento - Resultados"
        Quando clico no formulário da turma "BANCO DE DADOS"
        Então devo ver a mensagem "O formulário da turma BANCO DE DADOS ainda não possui respostas!"