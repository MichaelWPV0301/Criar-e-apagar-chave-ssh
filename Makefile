KEY_NAME = id_ed25519
EMAIL = email@endereco

# Regra padrão (opcional)
all:
	@echo "Use 'make criar' para configurar ou 'make remover' para limpar."

# ==== CRIAÇÃO ====
criar: gerar-chave iniciar-agent adicionar-chave mostrar-chave

iniciar-agent:
	@echo "⚠️  ssh-agent precisa ser iniciado no terminal atual."
	@echo "👉 Rode: eval \"\$$$(ssh-agent -s)\" antes de usar a chave."

gerar-chave:
	@echo "🔐 Gerando chave SSH..."
	ssh-keygen -t ed25519 -C "$(EMAIL)" -f ~/.ssh/$(KEY_NAME) -N ""


adicionar-chave:
	@echo "➕ Adicionando chave ao agente..."
	ssh-add ~/.ssh/$(KEY_NAME)

mostrar-chave:
	@echo "A chave criada foi essa:"
	cat ~/.ssh/$(KEY_NAME).pub

# ==== REMOÇÃO ====
remover: remover-chave encerrar-agent limpar-config limpar-remote

remover-chave:
	@echo "🧨 Removendo chaves SSH..."
	rm -f ~/.ssh/$(KEY_NAME) ~/.ssh/$(KEY_NAME).pub

encerrar-agent:
	@echo "🛑 Encerrando ssh-agent..."
	eval "$$(ssh-agent -k)"

limpar-config:
	@echo "🧹 Limpando configuração global do Git..."
	rm -f ~/.gitconfig
	git config --global --unset user.name || true
	git config --global --unset user.email || true

limpar-remote:
	@echo "🚫 Removendo remote do repositório atual (se existir)..."
	-git remote remove origin

