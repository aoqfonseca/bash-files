#!/bin/bash

# Define a cor verde para mensagens de sucesso
GREEN='\033[0;32m'
# Define a cor vermelha para mensagens de erro
RED='\033[0;31m'
# Define a cor amarela para avisos
YELLOW='\033[1;33m'
# Reseta a cor para o padrão
NC='\033[0m'

# Função para exibir uma mensagem de status
status_message() {
    echo -e "${YELLOW}--- $1 ---${NC}"
}

# Função para exibir uma mensagem de sucesso
success_message() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Função para exibir uma mensagem de erro
error_message() {
    echo -e "${RED}✗ $1${NC}"
    exit 1
}

# Função para verificar se um comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# --- Instalar dependências essenciais ---
install_dependencies() {
    status_message "Atualizando e instalando dependências essenciais..."
    sudo apt-get update || error_message "Falha ao atualizar a lista de pacotes."
    sudo apt-get install -y \
        build-essential \
	bash \
        curl \
        git \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        wget \
        llvm \
        libncurses5-dev \
        libncursesw5-dev \
        xz-utils \
	fzf \
        tk-dev || error_message "Falha ao instalar dependências essenciais."
    success_message "Dependências essenciais instaladas com sucesso."
}

# --- Instalar o Git ---
install_git() {
    status_message "Verificando e instalando Git..."
    if command_exists git; then
        success_message "Git já está instalado."
    else
        sudo apt-get install -y git || error_message "Falha ao instalar o Git."
        success_message "Git instalado com sucesso."
    fi
}

# --- Instalar e configurar o ASDF ---
install_asdf() {
    status_message "Instalando e configurando o ASDF..."
    if [ -d "$HOME/.asdf" ]; then
        success_message "ASDF já está instalado."
        return
    fi

    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch latest || error_message "Falha ao clonar o repositório do ASDF."

    # Adiciona a configuração do ASDF ao shell
    echo -e "\n. \"\$HOME/.asdf/asdf.sh\"" >> ~/.bashrc
    echo -e "\n. \"\$HOME/.asdf/completions/asdf.bash\"" >> ~/.bashrc

    # Recarrega o shell para que o ASDF esteja disponível
    source "$HOME/.bashrc" || error_message "Falha ao recarregar .bashrc."
    success_message "ASDF instalado e configurado com sucesso."
}

# --- Instalar e configurar Golang com ASDF ---
install_go() {
    status_message "Instalando Golang com ASDF..."
    asdf plugin add golang || { success_message "Plugin do Golang já está instalado." && asdf plugin update golang; }
    
    local latest_go=$(asdf list-all golang | grep -E '^1\.22\.[0-9]+$' | tail -1)
    
    if asdf list golang | grep -q "$latest_go"; then
        success_message "Golang $latest_go já está instalado."
    else
        asdf install golang "$latest_go" || error_message "Falha ao instalar Golang $latest_go."
        asdf set -u golang "$latest_go" || error_message "Falha ao definir Golang $latest_go como global."
        success_message "Golang $latest_go instalado e configurado como global."
    fi
}

# --- Instalar e configurar NodeJS com ASDF ---
install_node() {
    status_message "Instalando NodeJS com ASDF..."
    asdf plugin add nodejs || { success_message "Plugin do NodeJS já está instalado." && asdf plugin update nodejs; }

    bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring || error_message "Falha ao importar chaves GPG para NodeJS."
    
    local latest_node=$(asdf list-all nodejs | grep -E '^[0-9]+(\.[0-9]+){2}$' | tail -1)
    
    if asdf list nodejs | grep -q "$latest_node"; then
        success_message "NodeJS $latest_node já está instalado."
    else
        asdf install nodejs "$latest_node" || error_message "Falha ao instalar NodeJS $latest_node."
        asdf set -u  nodejs "$latest_node" || error_message "Falha ao definir NodeJS $latest_node como global."
        success_message "NodeJS $latest_node instalado e configurado como global."
    fi
}

# --- Instalar o GitHub CLI ---
install_github_cli() {
    status_message "Instalando GitHub CLI (gh)..."
    if command_exists gh; then
        success_message "GitHub CLI já está instalado."
        return
    fi
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y gh || error_message "Falha ao instalar GitHub CLI."
    success_message "GitHub CLI instalado com sucesso."
}

# --- Instalar o Google Cloud SDK ---
install_gcloud_sdk() {
    status_message "Instalando Google Cloud SDK (gcloud)..."
    if command_exists gcloud; then
        success_message "Google Cloud SDK já está instalado."
        return
    fi
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    sudo apt-get update
    sudo apt-get install -y google-cloud-sdk || error_message "Falha ao instalar Google Cloud SDK."
    success_message "Google Cloud SDK instalado com sucesso."
}

# --- Instalar a última versão do Neovim (AppImage) ---
install_neovim() {
    status_message "Instalando Neovim na versão mais recente (via AppImage)..."
    if command_exists nvim; then
        success_message "Neovim já está instalado."
        return
    fi

    local neovim_dir="$HOME/.local/bin"
    mkdir -p "$neovim_dir"
    
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage || error_message "Falha ao baixar Neovim AppImage."
    
    chmod u+x nvim.appimage
    mv nvim.appimage "$neovim_dir/nvim" || error_message "Falha ao mover Neovim AppImage."
    
    # Adiciona o diretório ao PATH se ainda não estiver
    if ! grep -q "export PATH=\"\$HOME/.local/bin:\$PATH\"" ~/.bashrc; then
        echo -e "\nexport PATH=\"\$HOME/.local/bin:\$PATH\"" >> ~/.bashrc
    fi
    
    source ~/.bashrc
    
    success_message "Neovim instalado com sucesso. Você pode precisar reiniciar seu terminal para que o comando 'nvim' funcione corretamente."
}

install_nerd_fonts() {
    status_message "Instalando Nerd Fonts..."
    local nerd_fonts_repo="https://github.com/ryanoasis/nerd-fonts.git"
    local fonts_dir="$HOME/.local/share/fonts"
    
    # Se o diretório já existir e não for um repositório git, deletar ou pedir confirmação
    if [ -d "$fonts_dir/nerd-fonts" ]; then
        status_message "Repositório Nerd Fonts já existe. Atualizando..."
        cd "$fonts_dir/nerd-fonts"
        git pull || error_message "Falha ao atualizar o repositório Nerd Fonts."
        cd -
    else
        mkdir -p "$fonts_dir"
        git clone --filter=blob:none --sparse "$nerd_fonts_repo" "$fonts_dir/nerd-fonts" || error_message "Falha ao clonar repositório Nerd Fonts."
        cd "$fonts_dir/nerd-fonts"
        git sparse-checkout set --no-cone || error_message "Falha ao configurar sparse checkout."
        git sparse-checkout add 'patched-fonts/*' || error_message "Falha ao adicionar pastas de fontes."
        git pull origin master || error_message "Falha ao baixar as fontes."
        cd -
    fi
    
    "$fonts_dir/nerd-fonts/install.sh" -y || error_message "Falha ao executar o script de instalação das fontes."
    
    success_message "Nerd Fonts instaladas com sucesso. Lembre-se de configurar a fonte no seu terminal."
}


install_nvim_kickstart() {
	local kickstart_repo="https://github.com/nvim-lua/kickstart.nvim.git"
	local config_dir="$HOME/.config/nvim/"

}

# --- Função principal para executar o script ---
main() {
    status_message "Iniciando a configuração do ambiente de desenvolvimento..."
    install_dependencies
    install_git
    # install_asdf
    install_go
    install_node
    install_github_cli
    install_gcloud_sdk
    install_neovim
    install_nerd_fonts
    
    status_message "Configuração completa!"
    echo -e "${GREEN}Seu ambiente de desenvolvimento está pronto!${NC}"
    echo -e "${YELLOW}Por favor, reinicie seu terminal ou execute 'source ~/.bashrc' para que todas as mudanças entrem em vigor.${NC}"
}

# Executa a função principal
main
