FactoryBot.define do
  # Usuário comum: discente ativo
  factory :usuario do
    sequence(:nome)        { |n| "Fulano #{n}" }
    sequence(:num_usuario) { |n| 10000000000 + n }
    sequence(:email)       { |n| "fulano#{n}@exemplo.com" }
    formacao { "graduando" }
    ocupacao { "discente" }
    e_admin  { false }
    esta_ativo { true }
    password { "Senh@123" }
    password_confirmation { "Senh@123" }
    curso { "Ciência da Computaçao" }
    sequence(:matricula) { |n| 10000000000 + n }

# Usuário docente comum ativo
    trait :docente do
      formacao { "DOUTORADO" }
      ocupacao { "docente" }
      curso { nil }
      matricula { nil }
      departamento { "CIC - CIÊNCIA DA COMPUTAÇÃO" }
    end

# Usuário admin ativo
    trait :admin do
      formacao { "DOUTORADO" }
      ocupacao { "docente" }
      e_admin  { true }
      departamento { "CIC - CIÊNCIA DA COMPUTAÇÃO" }
      curso { nil }
      matricula { nil }
    end

# Usuário discente novo (não ativo)
    trait :novo do
      esta_ativo { false }
    end
  end
end