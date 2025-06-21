# language: pt

Funcionalidade: Atualizar base de dados com os dados do SIGAA
    Eu como Administrador
    Quero atualizar a base de dados já existente com os dados atuais do sigaa
    A fim de corrigir a base de dados do sistema
    
    Contexto:
        Dado que estou logado como administrador
        E que estou na página "Gerenciamento"
        E que já existem turmas, matérias e participantes cadastrados
        Quando clico no botão "Importar dados"
        E vejo a mensagem "Dados já importados anteriormente!"

    Cenário: Sobrescrita de dados já criados anteriormente
        Quando clico no botão "Atualizar dados"
        Então devo ver a mensagem "Dados atualizados com sucesso!"

    Cenário: Manutenção de dados já criados anteriormente
        Quando clico no botão "Desistir"
        Então devo permanecer na página "Gerenciamento"