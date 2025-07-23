# Controlador responsável por renderizar a tela de Gerenciamento (método index).  
# Essa tela apresenta ao usuário com perfil de administrador as opções de ações disponíveis.  
# Controlador também é responsável por importar os dados do JSON para a base de dados (método importar_dados).  
# Controlador conta com diversos métodos auxiliares aos principais.  

class AdminController < ApplicationController
  before_action :requerer_admin

  # Renderiza tela de Gerenciamento, com opções de ação para o administrador.  
  #
  ## @note Não utiliza parâmetros, não retorna objetos, nem produz efeitos colaterais.  
  def index
    render :index
  end

  # Processa requisição de importação de dados.  
  #
  # @param params[:sobrescrever] [String] Opcional. Deve ser "true" para atualizar a base de dados  
  # @param params[:confirmacao] [String] Opcional. Deve ser "true" para renderizar tela de confirmação de atualização  
  # @note Possui como possíveis efeitos colaterais:  
  #   1. acréscimo e deleção de informações da base de dados (Usuario, Disciplina, Turma)
  #   2. renderização de tela de confirmação de atualização de dados
  #   3. envio de emails com senha provisória e token para usuários
  #   4. apresentação de mensagens sobre indisponibilidade de dados e sucesso na importação de dados  
  def importar_dados

    # 1) Os arquivos com dados estão disponíveis? 
    
    unless arquivos_existem?
      flash[:alert] = "Dados indisponíveis no momento! Tente novamente mais tarde ou entre em contato com o suporte técnico."
      redirect_to admin_path and return
    end

    # 2) O usuário já autorizou a sobrescrita de dados (parâmetro sobrescrever: true)?
    
    if params[:sobrescrever] == "true"
      atualiza_dados and return

    # 3) Já existem dados de disciplinas, turmas e discentes no banco?
    
    elsif ImportacaoDado.exists?
      redirect_to admin_path(confirmacao: true) and return

    # 4) Nunca houve importação de dados.
    else
      criar_disciplinas_turmas(@caminho_arquivo_disciplinas)
      criar_usuarios(@caminho_arquivo_membros)
      ImportacaoDado.create!(usuario: usuario_atual)   
      redirect_to admin_path, notice: "Dados importados com sucesso!" and return
    end
  end

  private

  # Importa informações sobre disciplinas e turmas do JSON para a base de dados  
  #
  # @param caminho_arquivo [Pathname]  
  # @note Não retorna dados, nem renderiza views. Tem como efeito colateral a adição de disciplinas e turma na base de dados.  
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

  # Importa informações sobre discentes e docentes do JSON para a base de dados  
  #
  # @param caminho_arquivo [Pathname]  
  # @note Não retorna dados, nem renderiza views. Tem como efeitos colaterais:  
  #   1. a adição de usuários à base de dados;
  #   2. a associação de usuários a turmas;
  #   3. o envio de emails para os usuários. 
  def criar_usuarios(caminho_arquivo)
    dados = JSON.parse(File.read(caminho_arquivo))

    dados.each do |entrada|

      # Encontrar disciplina
      disciplina = Disciplina.find_by!(codigo: entrada["code"])

      # Encontrar turma associada a essa disciplina
      turma = Turma.find_by!(
        codigo: entrada["classCode"],
        semestre: entrada["semester"],
        disciplina: disciplina
      )

      # Encontrar discentes
      discentes = entrada["discente"] || []

      # Encontrar docentes
      docentes = entrada["docente"]
      docentes = [docentes] if docentes.is_a?(Hash)
      docentes ||= []

      # Criar discentes
      discentes.each do |discente|
        criar_discente(discente, turma)  
      end

      # Criar docentes
      docentes.each do |docente|
        criar_docente(docente, turma)
      end
    end
  end

  # Gera senha provisória, que será enviada por email ao usuário criado.  
  #
  # @param nome [String] Nome do usuário  
  # @param usuario [Integer] Número de usuário  
  # @return [String] Senha provisória do usuário  
  # @note Não produz efeitos colaterais.    
  def gerar_senha(nome, usuario)
    primeira_letra = nome[0].downcase rescue "x"
    primeiros_digitos = usuario.to_s[0,4] || "0000"
    "#{primeira_letra}A__#{primeiros_digitos}"
  end

  # Verifica se os arquivos JSON existem  
  #
  # @return [Boolean] Deve ser true (se arquivos existirem) ou false (caso contrário).  
  # @note Não utiliza nenhum parâmetro, nem produz efeitos colaterais.  
  def arquivos_existem?
    caminho_base = Rails.root.join('..').cleanpath  # Obtém path do diretório em que localizados os arquivos (um nível acima da raiz do projeto)
    @caminho_arquivo_membros = caminho_base.join('class_members.json') # Monta o path do arquivo de membros de turmas
    @caminho_arquivo_disciplinas =  caminho_base.join('classes.json') # Monta o path do arquivo de disciplinas
    caminhos_arquivos = [@caminho_arquivo_membros, @caminho_arquivo_disciplinas]
    caminhos_arquivos.all? { |arquivo| File.exist?(arquivo) } # Checa se os arquivos existem
  end

  # Atualiza base de dados com informações do JSON  
  #
  # @param @caminho_arquivo_disciplinas [Pathname] Caminho para o JSON das disciplinas  
  # @param @caminho_arquivo_membros [Pathname] Caminho para o JSON dos membros de disciplinas  
  # @note Não retorna objetos, mas produz efeitos colaterais:  
  #   1. adição e remoção de informações da base de dados (Usuario, Disciplina, Turma);
  #   2. envio de emails com token e senha provisória para usuários;
  #   3. apresentação de mensagem de sucesso.
  def atualiza_dados
    Disciplina.destroy_all
    Usuario.where(e_admin: false).destroy_all

    criar_disciplinas_turmas(@caminho_arquivo_disciplinas)
    criar_usuarios(@caminho_arquivo_membros)

    ImportacaoDado.create!(usuario: usuario_atual)

    redirect_to admin_path, notice: "Dados atualizados com sucesso!"
  end

  # Cria um discente específico  
  #
  # @param discente [Hash] Contém informações sobre o discente  
  # @param turma [Hash] Contém informações sobre a turma da qual o discente é membro  
  # @note Não retorna nenhum valor, mas produz efeitos colaterais:  
  #   1. adição de informações da base de dados (Usuario);
  #   2. associação de discente à turma da qual é membro;
  #   3. envio de email com token e senha provisória para o discente criado.
  def criar_discente(discente, turma)
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
        
    # Matricular o usuário na turma
    usuario.turmas << turma unless usuario.turmas.include?(turma)

    # Enviar email
    token = usuario.signed_id(purpose: "password_reset", expires_in: 60.minutes)
    UsuarioMailer.with(usuario: usuario, senha_padrao: senha_padrao, token: token).enviar_senha.deliver_later      
  end

  # Cria um docente específico  
  #
  # @param docente [Hash] Contém informações sobre o docente  
  # @param turma [Hash] Contém informações sobre a turma da qual o docente é membro  
  # @note Não retorna nenhum valor, mas produz efeitos colaterais:  
  #   1. adição e remoção de informações da base de dados (Usuario);
  #   2. associação de docente à turma da qual é membro;
  #   3. envio de email com token e senha provisória para o docente criado.
  def criar_docente(docente, turma)
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

    # Associar o docente à turma
    usuario.turmas << turma unless usuario.turmas.include?(turma)

    # Enviar email
    token = usuario.signed_id(purpose: "password_reset", expires_in: 60.minutes)
    UsuarioMailer.with(usuario: usuario, senha_padrao: senha_padrao, token: token).enviar_senha.deliver_later      
  end
end