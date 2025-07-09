module FormulariosHelper
	def get_nome_professor turma
		professor = turma.usuarios.find_by :ocupacao => "docente"
		professor ? professor.nome : "N/A"
	end
end
