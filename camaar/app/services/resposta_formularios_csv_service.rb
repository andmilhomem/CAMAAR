##
# Classe para gerar o csv das respostas à um formulário

class RespostaFormulariosCsvService
    
    ##
    # Inicializa os atributos +formulario+ e +respostas+, de acordo com o formulario fornecido.
    def initialize formulario
        @formulario = formulario
        @respostas = RespostaFormulario.where :formulario => formulario
    end

    ##
    # Gera o conteúdo do arquivo csv, onde cada linha terá as seguintes informações:
    # id da resposta, data da resposta, número da questão e a resposta da questão
    def get_arquivo_csv
        CSV.generate do |csv|
            csv << ["id","data_resposta","num_questao","texto_resposta"]
            @respostas.each do |rf|
                rf.resposta_questaos.each do |rq|
                    csv << [rf.id,rf.data_resposta,rq.num_questao,rq.texto_resposta]
                end
            end
        end
    end

    ##
    # Gera um nome para o arquivo csv, de acordo com o nome da disciplina e
    # o nome do professor da turma.
    #
    # Caso o formulário não exista, o nome do arquivo será 'N/A.csv'.
    def get_nome_csv
		if @formulario.blank?
			return "N/A.csv"
		end
		"#{@formulario.turma.disciplina.nome}-#{@formulario.turma.nome_professor}.csv"
    end
end