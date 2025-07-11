class CreateImportacaoDados < ActiveRecord::Migration[8.0]
  def change
    create_table :importacao_dados do |t|
      t.references :usuario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
