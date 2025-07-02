# language: pt

Funcionalidade: Criar template de formulário
    Eu como Administrador
    Quero criar um template de formulário contendo as questões do formulário
    A fim de gerar formulários de avaliações para avaliar o desempenho das turmas    ]
    
    Contexto:
        Dado que estou logado como administrador
        E que estou na página "Gerenciamento - Templates"
        Quando clico no botão "Adicionar template"
        E preencho o campo "Nome do template" com o valor "Formulário de desempenho"    
    
    Cenário: Template criado com sucesso
        Quando seleciono a opção "Texto" na caixa "Tipo" dentro de "Questão 1"
        E preencho o campo "Texto" dentro de "Questão 1" com o valor "Pontos positivos do professor"
        E clico no botão "Adicionar questão"
        E seleciono a opção "Radio" na caixa "Tipo" dentro de "Questão 2"
        E preencho o campo "Texto" dentro de "Questão 2" com o valor "Você gostou do desempenho do professor?"
        E preencho o campo "Opção 1" dentro de "Questão 2" com o valor "Sim"
        E preencho o campo "Opção 2" dentro de "Questão 2" com o valor "Não"
        E clico no botão "Criar"
        Então devo ver a mensagem "Template criado com sucesso!"
        E devo ver o template "Formulário de desempenho"

    Cenário: Tentar salvar uma questão de texto sem enunciado
        Quando seleciono a opção "Texto" na caixa "Tipo" dentro de "Questão 1"
        E clico no botão "Criar"
        Então devo ver a mensagem "O enunciado da questão é obrigatório!"

    Cenário: Tentar salvar uma questão de marcação sem opções
        Quando seleciono a opção "Radio" na caixa "Tipo" dentro de "Questão 1"
        E preencho o campo "Texto" dentro de "Questão 1" com o valor "Você gostou do desempenho do professor?"
        E clico no botão "Criar"
        Então devo ver a mensagem "A questão de marcação deve conter pelo menos uma opção de resposta!"