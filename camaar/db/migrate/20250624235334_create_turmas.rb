class CreateTurmas < ActiveRecord::Migration[8.0]
  def change
    create_table :turmas do |t|
      t.string :codigo, null: false
      t.string :semestre, null: false
      t.string :horario, null: false
      
      t.references :disciplina, null: false, foreign_key: true

      t.timestamps
    end
  end
end
