FactoryBot.define do
  factory :turma do
    sequence(:codigo)   { |n| "T#{n}" }
    semestre            { "2024.2" }
    horario             { "35T45" }
    disciplina
  end
end