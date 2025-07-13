# language: pt

Funcionalidade: Sistema de definição de senha
    Eu como Usuário
    Quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro
    A fim de acessar o sistema
    
    Contexto:
        Dado que estou logado como novo usuário
        E que estou na página "Redefinição de senha"

    Cenário: Usuário preenche a senha conforme padrão
        Quando preencho o campo "Nova Senha" com o valor "12ABcd$$"
        E preencho o campo "Repita sua Nova Senha" com o valor "12ABcd$$"
        E clico no botão "Salvar Nova Senha"
        Então devo ir para a página "Login"
        E devo ver a mensagem "Sua senha foi atualizada com sucesso!"

    Cenário: Usuário preenche a senha de forma inválida
        Quando preencho o campo "Nova Senha" com o valor "123456"
        E preencho o campo "Repita sua Nova Senha" com o valor "123456"
        E clico no botão "Salvar Nova Senha"
        Então devo ir para a página "Redefinição de senha"
        E devo ver a mensagem "Password deve conter no mínimo 8 caracteres, incluindo uma letra maiúscula, uma minúscula, um número e um caractere especial."

    Cenário: Senhas diferentes
        Quando preencho o campo "Nova Senha" com o valor "12ABcd$$"
        Mas preencho o campo "Repita sua Nova Senha" com o valor "12abCD$$"
        E clico no botão "Salvar Nova Senha"
        Então devo ver a mensagem "Password confirmation doesn't match Password"
  