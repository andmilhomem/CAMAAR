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
        Então devo ir para a página inicial

    Cenário: Usuário não cadastrado
        Quando preencho o campo "Email" com um e-mail não correspondente a um usuário cadastrado
        E preencho o campo "Senha" com qualquer valor
        E clico no botão "Entrar"
        Então devo permanecer na página "Login"
        E devo ver a mensagem "Email ou senha inválidos!"
    
    Cenário: Senha incorreta
        Quando preencho o campo "Email" com um e-mail correspondente a um usuário cadastrado
        Mas preencho o campo "Senha" com senha não correspondente a esse usuário
        E clico no botão "Entrar"
        Então devo permanecer na página "Login"
        Então devo ver a mensagem "Email ou senha inválidos!"
        