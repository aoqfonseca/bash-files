#!/bin/bash

source install_nerd_fonts_macos.sh
source install_nerd_fonts_linux.sh


# Get OS name
echo "🔍 Verificando o Sistema Operacional..."
OS="$(uname -s)"

case "${OS}" in
    Linux*)     
        install_fonts_linux
        ;;
    Darwin*)    
        install_fonts_macos
        ;;
    CYGWIN*|MINGW*|MINGW32*|MSYS*)
        echo "❌ Erro: Este script não suporta Windows de forma nativa."
        ;;
    *)          
        echo "❌ Sistema operacional não reconhecido: ${OS}"
        exit 1
        ;;
esac

echo "👉 IMPORTANTE: Lembre-se de configurar a fonte instalada nas preferências do seu terminal!"
