# language: pt

Funcionalidade: Cadastrar usuários do sistema
        Eu como Administrador
        Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuarios novos para o sistema
        A fim de que eles acessem o sistema CAMAAR
    
    Cenário: Redefinição de senha a partir da tela de login
        Dado que estou na página "Login"
        Quando preencho o campo "Email" com um e-mail de usuário novo
        E preencho o campo "Senha" com a senha correspondente a esse usuário
        E clico no botão "Entrar"
        Então devo ir para a página "Redefinição de senha"
    
    Cenário: Redefinição de senha a partir de link        
        Quando clico no link de redefinição de senha recebido por e-mail
        Então devo ir para a página "Redefinição de senha"