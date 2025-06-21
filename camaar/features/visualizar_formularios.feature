# language: pt

Funcionalidade: Visualização de formulários para responder
    Eu como Participante de uma turma
    Quero visualizar os formulários não respondidos das turmas em que estou matriculado
    A fim de poder escolher qual irei responder

    Contexto:
        Dado que estou logado como participante
        E que estou matriculado na turma "BANCO DE DADOS"
        E que estou na página "Avaliações"

    Cenário: Visualizar formulários disponíveis
        Dado que existe um formulário não respondido na turma "BANCO DE DADOS"
        Então devo ver o formulário da turma "BANCO DE DADOS"

    Cenário: Nenhum formulário disponível
        Dado que já respondi o formulário da turma "BANCO DE DADOS"
        Então devo ver a "Nenhum formulário disponível para resposta"