class AdminController < ApplicationController
  before_action :requerer_admin
  
  def index
    render :index
  end

  def importar_dados

    # 1) Os arquivos com dados estão disponíveis? 
    
    caminho_base = Rails.root.join('..').cleanpath  # Obtém path do diretório em que localizados os arquivos (um nível acima da raiz do projeto)

    caminho_arquivo_membros = caminho_base.join('class_members.json') # Monta o path do arquivo de membros de turmas
    caminho_arquivo_disciplinas =  caminho_base.join('classes.json') # Monta o path do arquivo de disciplinas
    
    caminhos_arquivos = [caminho_arquivo_membros, caminho_arquivo_disciplinas]

    arquivos_existem = caminhos_arquivos.all? { |arquivo| File.exist?(arquivo) } # Checa se os arquivos existem

    unless arquivos_existem
      flash[:alert] = "Dados indisponíveis no momento! Tente novamente mais tarde ou entre em contato com o suporte técnico."
      redirect_to admin_path and return
    end

    # 2) O usuário já autorizou a sobrescrita de dados (parâmetro sobrescrever: true)?
    
    if params[:sobrescrever] == "true"
      
      Disciplina.destroy_all
      Usuario.where(e_admin: false).destroy_all

      criar_disciplinas_turmas(caminho_arquivo_disciplinas)
      criar_usuarios(caminho_arquivo_membros)

      redirect_to admin_path, notice: "Dados atualizados com sucesso!" and return

    # 3) Já existem dados de disciplinas, turmas e discentes no banco?
    
    elsif Disciplina.exists? || Turma.exists? || Usuario.where(e_admin: false).exists?
      redirect_to admin_path(confirmacao: true) and return

    else
      criar_disciplinas_turmas(caminho_arquivo_disciplinas)
      criar_usuarios(caminho_arquivo_membros)

      redirect_to admin_path, notice: "Dados importados com sucesso!" and return
    end
  end

  private

  def criar_disciplinas_turmas(caminho_arquivo)
    dados = JSON.parse(File.read(caminho_arquivo))

    dados.each do |entrada|
      disciplina = Disciplina.find_or_create_by!(
        codigo: entrada["code"],
        nome: entrada["name"]
      )

      turmas = entrada["class"]

      turmas = [turmas] unless turmas.is_a?(Array)

      turmas.each do |turma_data|
        Turma.find_or_create_by!(
          codigo: turma_data["classCode"],
          semestre: turma_data["semester"],
          horario: turma_data["time"],
          disciplina: disciplina
        )
      end
    end
  end

  def criar_usuarios(caminho_arquivo)
    dados = JSON.parse(File.read(caminho_arquivo))

    dados.each do |entrada|

      discentes = entrada["discente"] || []

      discentes.each do |discente|
        senha_padrao = gerar_senha(discente["nome"], discente["usuario"])
        usuario = Usuario.find_or_initialize_by(num_usuario: discente["usuario"].to_i)
        usuario.assign_attributes(
          nome: discente["nome"],
          formacao: discente["formacao"],
          ocupacao: discente["ocupacao"],
          email: discente["email"],
          curso: discente["curso"],
          matricula: discente["matricula"].to_i,
          e_admin: false,
          esta_ativo: false,
          password: senha_padrao
        )
        usuario.save!
        UsuarioMailer.with(usuario: usuario, senha_padrao: senha_padrao).enviar_senha.deliver_later
      end

      docentes = entrada["docente"]
      docentes = [docentes] if docentes.is_a?(Hash)
      docentes ||= []

      docentes.each do |docente|
        senha_padrao = gerar_senha(docente["nome"], docente["usuario"])
        usuario = Usuario.find_or_initialize_by(num_usuario: docente["usuario"].to_i)
        usuario.assign_attributes(
          nome: docente["nome"],
          formacao: docente["formacao"],
          ocupacao: docente["ocupacao"],
          email: docente["email"],
          departamento: docente["departamento"],
          e_admin: false,
          esta_ativo: false,
          password: senha_padrao
        )
        usuario.save!
        UsuarioMailer.with(usuario: usuario, senha_padrao: senha_padrao).enviar_senha.deliver_later
      end
    end
  end

  def gerar_senha(nome, usuario)
    primeira_letra = nome[0].downcase rescue "x"
    primeiros_digitos = usuario.to_s[0,4] || "0000"
    "#{primeira_letra}a__#{primeiros_digitos}"
  end

end
