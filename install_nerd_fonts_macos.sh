#!/bin/bash

install_fonts_macos() {
    echo "🚀 Iniciando a instalação das Nerd Fonts..."

    # 1. Verifica se o Homebrew está instalado
    if ! command -v brew &> /dev/null; then
        echo "📦 Homebrew não encontrado. Instalando o Homebrew primeiro..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "✅ Homebrew já está instalado. Atualizando repositórios..."
        brew update
    fi

    # 2. Lista das Nerd Fonts mais populares
    # Você pode adicionar ou remover fontes desta lista conforme o seu gosto
    FONTS=(
        "font-fira-code-nerd-font"
        "font-hack-nerd-font"
        "font-inconsolata-nerd-font"
        "font-iosevka-nerd-font"
        "font-meslo-lg-nerd-font"
        "font-jetbrains-mono-nerd-font"
        "font-victor-nerd-font"
    )

    echo "🔤 Instalando as fontes..."

    # 3. Loop para instalar cada fonte da lista
    for font in "${FONTS[@]}"; do
        # VERIFICAÇÃO: A fonte já está instalada?
        echo "🔍 Verificando se a fonte já está instalada..."
        if brew list --cask "$font" &> /dev/null; then
            echo "✅ A fonte '$font' já está instalada no seu Mac. Nenhuma ação necessária!"
            continue
        fi
        echo "⏳ Instalando $font..."
        brew install --cask "$font"
    done

    echo "🎉 Instalação concluída com sucesso!"
    echo "👉 IMPORTANTE: Não se esqueça de ir nas preferências do seu Terminal (ou iTerm2) e alterar a fonte principal para uma das Nerd Fonts instaladas."
}
