class CreateQuestaos < ActiveRecord::Migration[8.0]
  def change
    create_table :questaos do |t|
      t.integer :num_questao
      t.string :tipo
      t.string :enunciado

      t.references :template, null: false, foreign_key: true

      t.timestamps
    end
  end
end
