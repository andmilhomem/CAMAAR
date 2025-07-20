class RespostaFormulariosCsvService
    
    def initialize formulario
        @formulario = formulario
        @respostas = RespostaFormulario.where :formulario => formulario
    end
    
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

    def get_nome_csv
		if @formulario.blank?
			return "N/A.csv"
		end
		"#{@formulario.turma.disciplina.nome}-#{@formulario.turma.nome_professor}.csv"
    end
end