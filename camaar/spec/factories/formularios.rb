FactoryBot.define do
  factory :formulario do
    data_criacao { Time.current }
    turma

    # Formulário gerado a partir do template de duas questoes
    trait :com_duas_questoes do
      after(:create) do |formulario|
        template = create(:template, :com_duas_questoes)

        template.questaos.each do |questao_template|
          nova_questao = create(:questao,
            num_questao: questao_template.num_questao,
            tipo: questao_template.tipo,
            enunciado: questao_template.enunciado,
            template: template,
            formulario: formulario
          )

          questao_template.opcaos.each do |opcao_template|
            create(:opcao,
              num_opcao: opcao_template.num_opcao,
              texto_opcao: opcao_template.texto_opcao,
              questao: nova_questao
            )
          end
        end
      end
    end
  end
end