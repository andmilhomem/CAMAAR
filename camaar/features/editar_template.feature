# language: pt

Funcionalidade: Edição e deleção de templates
    Eu como Administrador
    Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
    A fim de organizar os templates existentes
    
    Contexto:
        Dado que estou logado como administrador
        E que existe um template previamente criado com o nome "Formulário de opinião"
        E que estou na página "Gerenciamento - Templates"
    
    Cenário: Editar um template existente com sucesso
        Quando clico no botão "Editar template" dentro do template "Formulário de opinião"
        E preencho o campo "Nome do template" com o valor "Formulário de desempenho"
        E clico no botão "Salvar"
        Então devo ver a mensagem "Template atualizado com sucesso!"
        E devo ver o template "Formulário de desempenho"
    
    Cenário: Editar um template existente com campo inválido
        Quando clico no botão "Editar template" dentro do template "Formulário de opinião"
        E apago o conteúdo do campo "Nome do template"
        E clico no botão "Salvar"
        Então devo ver a mensagem "Nome do template não pode ser vazio!"

    Cenário: Deletar um template existente com sucesso
        Quando clico no botão "Deletar template" dentro do template "Formulário de opinião"
        E vejo a mensagem "Deseja deletar mesmo?"
        E clico no botão "Sim"
        Então devo ver a mensagem "Template deletado com sucesso!"
        E não devo mais ver o template "Formulário de opinião"