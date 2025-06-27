class CreateQuestaos < ActiveRecord::Migration[8.0]
  def change
    create_table :questaos do |t|
      t.integer :num_questao, null: false
      t.string :tipo, null: false
      t.string :enunciado, null: false

      t.references :template, null: false, foreign_key: true
      t.references :formulario, foreign_key: true

      t.timestamps
    end
  end
end
