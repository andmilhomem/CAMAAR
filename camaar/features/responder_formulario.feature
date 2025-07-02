# language: pt

Funcionalidade: Responder formulário
    Eu como Participante de uma turma
    Quero responder o questionário sobre a turma em que estou matriculado
    A fim de submeter minha avaliação da turma

    Contexto:
        Dado que estou logado como participante
        E que estou matriculado na turma "BANCO DE DADOS"
        E que estou na página "Avaliações"
        E que existe um formulário não respondido na turma "BANCO DE DADOS" com uma questão do tipo "Texto" e outra do tipo "Radio" com duas opções, "Sim" e "Não"
        Quando clico no formulário da turma "BANCO DE DADOS"

    Cenário: Enviar formulário preenchido com sucesso
        Quando informo o valor "Lorem ipsum" dentro de "Questão 1"
        E seleciono a opção "Não" dentro de "Questão 2"
        E clico no botão "Enviar"
        Então devo ver a mensagem "Resposta enviada com sucesso!"

    Cenário: Tentar enviar formulário incompleto
        Quando clico no botão "Enviar"
        Então devo ver a mensagem "Todos os campos devem ser preenchidos!" 