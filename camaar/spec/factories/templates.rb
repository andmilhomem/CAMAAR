FactoryBot.define do
  factory :template do
    sequence(:nome) { |n| "Avaliação de desempenho #{n}" }
    data_versao { Time.current }

    # Cria template com duas questões (uma tipo texto, outra tipo radio)
    trait :com_duas_questoes do
      after(:create) do |template|
        create(:questao,
          template: template,
          tipo: "Texto",
          num_questao: 1,
          enunciado: "Em uma palavra, como você define seu desempenho no semestre?"
        )

        questao_radio = create(:questao,
          template: template,
          tipo: "Radio",
          num_questao: 2,
          enunciado: "Você merece ser aprovado?"
        )

        create(:opcao, questao: questao_radio, num_opcao: 1, texto_opcao: "Sim")
        create(:opcao, questao: questao_radio, num_opcao: 2, texto_opcao: "Não")
      end
    end
  end
end