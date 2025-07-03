FactoryBot.define do
  factory :questao do
    sequence(:num_questao) { |n| n }
    tipo { "Texto" }
    sequence(:enunciado) { |n| "Enunciado #{n}?" }
    template

    trait :radio do
      tipo { "Radio" }
    end

    trait :para_formulario do
      formulario
    end
  end
end