# language: pt

Funcionalidade: Importar dados do SIGAA
    Como Administrador
    Quero importar dados de turmas, matérias e participantes do SIGAA (caso não existam na base de dados atual)
    A fim de alimentar a base de dados do sistema

    Contexto:
        Dado que estou logado como administrador
        E que estou na página "Gerenciamento"
        E que ainda não existem turmas, matérias e participantes cadastrados

    Cenário: Importação bem-sucedida
        Dado que os dados estão disponíveis para importação
        Quando clico no botão "Importar dados"
        Então devo ver a mensagem "Dados importados com sucesso!"

    Cenário: Dados indisponíveis
        Dado que os dados não estão disponíveis para importação
        Quando clico no botão "Importar dados"
        Então devo ver a mensagem "Dados indisponíveis no momento! Tente novamente mais tarde ou entre em contato com o suporte técnico."