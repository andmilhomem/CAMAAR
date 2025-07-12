require 'rails_helper'

RSpec.describe Template, type: :model do
  it 'é válido com nome e data_versao' do
    template = build(:template)
    expect(template).to be_valid
  end

  it 'é inválido sem nome' do
    template = build(:template, nome: nil)
    expect(template).not_to be_valid
  end

  it 'pode ter várias questões associadas' do
    template = create(:template)
    create_list(:questao, 3, template: template)
    expect(template.questaos.count).to eq(3)
  end

  it 'remove as questões associadas ao ser destruído' do
    template = create(:template)
    create_list(:questao, 2, template: template)
    expect { template.destroy }.to change { Questao.count }.by(-2)
  end

  it 'aceita nested attributes para questões' do
    template = Template.create!(
      nome: 'Avaliação Nested',
      questaos_attributes: [
        { num_questao: 1, tipo: 'Texto', enunciado: 'Q1?' },
        { num_questao: 2, tipo: 'Radio', enunciado: 'Q2?' }
      ]
    )
    expect(template.questaos.count).to eq(2)
  end

  it 'aceita nested attributes para questões e opções' do
    template = Template.create!(
      nome: 'Avaliação Nested',
      questaos_attributes: [
        {
          num_questao: 1,
          tipo: 'Radio',
          enunciado: 'Q1?',
          opcaos_attributes: [
            { num_opcao: 1, texto_opcao: 'Sim' },
            { num_opcao: 2, texto_opcao: 'Não' }
          ]
        }
      ]
    )
    questao = template.questaos.first
    expect(questao.opcaos.count).to eq(2)
  end

  it 'não permite nomes duplicados' do
    create(:template, nome: 'Avaliação')
    novo = build(:template, nome: 'Avaliação')
    expect(novo).not_to be_valid
  end

  it 'não permite nome maior que 100 caracteres' do
    template = build(:template, nome: 'a' * 101)
    expect(template).not_to be_valid
  end

  it 'remove opções ao remover questão' do
    template = create(:template, :com_duas_questoes)
    questao_radio = template.questaos.find_by(tipo: 'Radio')
    expect { questao_radio.destroy }.to change { Opcao.count }.by(-2)
  end

  it 'atualiza questões via nested attributes' do
    template = create(:template, :com_duas_questoes)
    questao = template.questaos.first
    template.update!(
      questaos_attributes: [
        { id: questao.id, enunciado: 'Novo enunciado' }
      ]
    )
    expect(questao.reload.enunciado).to eq('Novo enunciado')
  end
end