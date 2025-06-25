class CreateFormularios < ActiveRecord::Migration[8.0]
  def change
    create_table :formularios do |t|
      t.datetime :data_criacao

      t.references :turma, null: false, foreign_key: true

      t.timestamps
    end
  end
end
