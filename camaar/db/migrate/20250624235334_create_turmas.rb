class CreateTurmas < ActiveRecord::Migration[8.0]
  def change
    create_table :turmas do |t|
      t.string :codigo, null: false
      t.string :semestre, null: false
      t.string :horario, null: false
      t.timestamps

      t.references :disciplina, null: false, foreign_key: true
    end
  end
end
