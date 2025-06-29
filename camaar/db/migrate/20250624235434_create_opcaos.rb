class CreateOpcaos < ActiveRecord::Migration[8.0]
  def change
    create_table :opcaos do |t|
      t.integer :num_opcao, null: false
      t.string :texto_opcao, null: false

      t.references :questao, null: false, foreign_key: true

      t.timestamps
    end
  end
end
