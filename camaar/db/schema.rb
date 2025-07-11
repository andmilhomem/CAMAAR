# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_11_215834) do
  create_table "disciplinas", force: :cascade do |t|
    t.string "codigo", null: false
    t.string "nome", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_disciplinas_on_codigo", unique: true
    t.index ["nome"], name: "index_disciplinas_on_nome", unique: true
  end

  create_table "formularios", force: :cascade do |t|
    t.datetime "data_criacao"
    t.integer "turma_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["turma_id"], name: "index_formularios_on_turma_id"
  end

  create_table "formularios_usuarios", id: false, force: :cascade do |t|
    t.integer "usuario_id", null: false
    t.integer "formulario_id", null: false
    t.index ["formulario_id", "usuario_id"], name: "index_formularios_usuarios_on_formulario_id_and_usuario_id"
    t.index ["usuario_id", "formulario_id"], name: "index_formularios_usuarios_on_usuario_id_and_formulario_id"
  end

  create_table "importacao_dados", force: :cascade do |t|
    t.integer "usuario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["usuario_id"], name: "index_importacao_dados_on_usuario_id"
  end

  create_table "opcaos", force: :cascade do |t|
    t.integer "num_opcao", null: false
    t.string "texto_opcao", null: false
    t.integer "questao_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questao_id"], name: "index_opcaos_on_questao_id"
  end

  create_table "questaos", force: :cascade do |t|
    t.integer "num_questao", null: false
    t.string "tipo", null: false
    t.string "enunciado", null: false
    t.integer "template_id", null: false
    t.integer "formulario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_questaos_on_formulario_id"
    t.index ["template_id"], name: "index_questaos_on_template_id"
  end

  create_table "resposta_formularios", force: :cascade do |t|
    t.datetime "data_resposta"
    t.integer "formulario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_resposta_formularios_on_formulario_id"
  end

  create_table "resposta_questaos", force: :cascade do |t|
    t.string "texto_resposta", null: false
    t.integer "num_questao", null: false
    t.integer "resposta_formulario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resposta_formulario_id"], name: "index_resposta_questaos_on_resposta_formulario_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "nome", null: false
    t.datetime "data_versao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "turmas", force: :cascade do |t|
    t.string "codigo", null: false
    t.string "semestre", null: false
    t.string "horario", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "disciplina_id", null: false
    t.index ["disciplina_id"], name: "index_turmas_on_disciplina_id"
  end

  create_table "turmas_usuarios", id: false, force: :cascade do |t|
    t.integer "usuario_id", null: false
    t.integer "turma_id", null: false
    t.index ["turma_id", "usuario_id"], name: "index_turmas_usuarios_on_turma_id_and_usuario_id", unique: true
    t.index ["usuario_id", "turma_id"], name: "index_turmas_usuarios_on_usuario_id_and_turma_id", unique: true
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "nome", null: false
    t.string "formacao", null: false
    t.string "ocupacao", null: false
    t.integer "num_usuario", null: false
    t.string "email", null: false
    t.boolean "e_admin", default: false, null: false
    t.boolean "esta_ativo", default: false, null: false
    t.string "password_digest", null: false
    t.string "curso"
    t.integer "matricula"
    t.string "departamento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_usuarios_on_email", unique: true
    t.index ["matricula"], name: "index_usuarios_on_matricula", unique: true
    t.index ["num_usuario"], name: "index_usuarios_on_num_usuario", unique: true
  end

  add_foreign_key "formularios", "turmas"
  add_foreign_key "importacao_dados", "usuarios"
  add_foreign_key "opcaos", "questaos"
  add_foreign_key "questaos", "formularios"
  add_foreign_key "questaos", "templates"
  add_foreign_key "resposta_formularios", "formularios"
  add_foreign_key "resposta_questaos", "resposta_formularios"
  add_foreign_key "turmas", "disciplinas"
end
