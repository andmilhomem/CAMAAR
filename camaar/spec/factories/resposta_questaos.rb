FactoryBot.define do
  factory :resposta_questao do
    sequence(:num_questao) { |n| n }
    sequence(:texto_resposta) { |n| "Resposta #{n}" }
    resposta_formulario
  end
end