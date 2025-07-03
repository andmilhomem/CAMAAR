FactoryBot.define do
  factory :resposta_formulario do
    data_resposta { Time.current }
    formulario

    trait :com_duas_questoes do
      after(:build) do |resposta_formulario|
        formulario = create(:formulario, :com_duas_questoes)
        resposta_formulario.formulario = formulario
      end

      after(:create) do |resposta_formulario|
        create(:resposta_questao,
          resposta_formulario: resposta_formulario,
          num_questao: 1,
          texto_resposta: "Suficiente"
        )
        create(:resposta_questao,
          resposta_formulario: resposta_formulario,
          num_questao: 2,
          texto_resposta: "Sim"
        )
      end
    end
  end
end