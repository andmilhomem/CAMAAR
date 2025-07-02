# language: pt

Funcionalidade: Sistema de definição de senha
    Eu como Usuário
    Quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro
    A fim de acessar o sistema
    
    Contexto:
        Dado que estou logado como novo usuário
        E que estou na página "Redefinição de senha"

    Cenário: Usuário preenche a senha conforme padrão
        Quando preencho o campo "Senha" com o valor "12ABcd$$"
        E preencho o campo "Confirme a senha" com o valor "12ABcd$$"
        E clico no botão "Alterar senha"
        Então devo ir para a página "Avaliações"
        E devo ver a mensagem "Senha redefinida com sucesso!"

    Cenário: Usuário preenche a senha de forma inválida
        Quando preencho o campo "Senha" com o valor "123456"
        E preencho o campo "Confirme a senha" com o valor "123456"
        E clico no botão "Alterar senha"
        Então devo ir para a página "Avaliações"
        E devo ver a mensagem "Formato de senha inválido!"

    Cenário: Senhas diferentes
        Quando preencho o campo "Senha" com o valor "12ABcd$$"
        Mas preencho o campo "Confirme a senha" com o valor "12abCD$$"
        E clico no botão "Alterar senha"
        Então devo ver a mensagem "Senhas diferentes!"
  