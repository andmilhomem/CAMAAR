# language: pt

Funcionalidade: Sistema de login
    Eu como Usuário do sistema
    Quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
    A fim de responder formulários ou gerenciar o sistema

    Contexto:
        Dado que estou na página "Login"

    Cenário: Usuário cadastrado
        Quando preencho o campo "Email" com um e-mail correspondente a um usuário cadastrado
        E preencho o campo "Senha" com a senha correspondente a esse usuário
        E clico no botão "Entrar"
        Então devo ir para a página "Avaliações"

    Cenário: Usuário não cadastrado
        Quando preencho o campo "Email" com um e-mail não correspondente a um usuário cadastrado
        E clico no botão "Entrar"
        Então devo ver a mensagem "Usuário ou Senha Inválidos"
    
    Cenário: Senha incorreta
        Quando preencho o campo "Email" com um e-mail correspondente a um usuário cadastrado
        Mas preencho o campo "Senha" com senha não correspondente a esse usuário
        E clico no botão "Entrar"
        Então devo ver a mensagem "Usuário ou Senha Inválidos"
        