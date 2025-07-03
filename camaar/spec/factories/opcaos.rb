FactoryBot.define do
  factory :opcao do
    sequence(:num_opcao) { |n| n }
    sequence(:texto_opcao) { |n| "Opção #{n}" }
    questao
  end
end