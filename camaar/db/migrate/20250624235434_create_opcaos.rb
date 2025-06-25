class CreateOpcaos < ActiveRecord::Migration[8.0]
  def change
    create_table :opcaos do |t|
      t.integer :num_opcao
      t.string :texto_opcao

      t.references :questao, null: false, foreign_key: true


      t.timestamps
    end
  end
end
