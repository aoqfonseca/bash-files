#!/bin/bash
install_fonts_linux() {
    echo "🚀 Iniciando a instalação das Nerd Fonts no Linux..."

    # Verifica se os comandos necessários estão instalados
    if ! command -v wget &> /dev/null || ! command -v unzip &> /dev/null || ! command -v fc-cache &> /dev/null; then
        echo "❌ Erro: Este script precisa do 'wget', 'unzip' e 'fontconfig' (fc-cache) instalados."
        echo "Instale-os usando o gerenciador de pacotes da sua distribuição (ex: sudo apt install wget unzip fontconfig) e tente novamente."
        exit 1
    fi

    # Define a versão mais recente e o diretório de destino
    VERSION="v3.4.0"
    FONT_DIR="$HOME/.local/share/fonts"

    # Cria a pasta de fontes do usuário, caso não exista
    mkdir -p "$FONT_DIR"

    # Lista das fontes a serem instaladas (nomes exatos dos arquivos .zip no GitHub)
    FONTS=(
        "FiraCode"
        "Hack"
        "Meslo"
        "JetBrainsMono"
        "Inconsolata"
        "Iosevka"
        "VictorMono"
    )

    echo "🔤 Baixando e instalando as fontes..."

    # Loop para baixar e extrair cada fonte
    for font in "${FONTS[@]}"; do
        FONT_NAME_DIR="$HOME/.local/share/fonts/$font"
        echo "🔍 Verificando se a fonte já está instalada..."
        if [ -d "$FONT_NAME_DIR" ] && [ "$(ls -A "$FONT_NAME_DIR" 2>/dev/null)" ]; then
            echo "✅ O diretório '$FONT_NAME_DIR' já existe e não está vazio."
            echo "✅ A fonte '$font' já parece estar instalada. Nenhuma ação necessária!"
            continue
        fi

        echo "----------------------------------------"
        echo "⏳ Baixando $font..."
        
        # Baixa o arquivo zip diretamente do GitHub
        wget -q --show-progress -O "$FONT_DIR/$font.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/$VERSION/$font.zip"
        
        echo "📦 Extraindo $font..."
        # Cria uma subpasta para manter tudo organizado e extrai
        mkdir -p "$FONT_DIR/$font"
        unzip -q -o "$FONT_DIR/$font.zip" -d "$FONT_DIR/$font"
        
        # Remove o arquivo .zip para economizar espaço
        rm "$FONT_DIR/$font.zip"
    done

    echo "----------------------------------------"
    echo "🔄 Atualizando o cache de fontes do sistema (isso pode levar alguns segundos)..."
    fc-cache -fv &> /dev/null

    echo "🎉 Instalação concluída com sucesso!"
    echo "👉 IMPORTANTE: Agora você precisa abrir as preferências do seu emulador de terminal e selecionar a fonte instalada."
}
