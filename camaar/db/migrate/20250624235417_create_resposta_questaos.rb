class CreateRespostaQuestaos < ActiveRecord::Migration[8.0]
  def change
    create_table :resposta_questaos do |t|
      t.string :texto_resposta, null: false

      t.references :resposta_formulario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
