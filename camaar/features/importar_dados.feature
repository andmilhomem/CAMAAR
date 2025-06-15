# language: pt

Funcionalidade: Importar dados do SIGAA
    Como Administrador
    Quero importar dados de turmas, matérias e participantes do SIGAA (caso não existam na base de dados atual)
    A fim de alimentar a base de dados do sistema

    Contexto:
        Dado que eu tenho perfil de Administrador
        E que eu estou na página "Gerenciamento"

    Cenário: importação bem sucedida (happy path)
        Dado que ainda não existem turmas, matérias e participantes cadastrados
        Quando eu clico em "Importar dados"
        Então eu vejo a mensagem "Dados importados com sucesso!"

    Cenário: dados já criados (sad path)
        Dado que já existem turmas, matérias e participantes cadastrados
        Quando eu clico em "Importar dados"
        Então eu vejo a mensagem "Dados já importados anteriormente!"
