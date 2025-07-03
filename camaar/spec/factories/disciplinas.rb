FactoryBot.define do
  factory :disciplina do
    sequence(:codigo) { |n| "CIC00#{n}" }
    sequence(:nome)   { |n| "Tópicos em Computação #{n}" }
  end
end