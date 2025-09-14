#!/bin/bash

# Guia Rápido de Instalação
# Execute este comando no Termux para instalação automática:
# curl -fsSL https://raw.githubusercontent.com/wiversonlima/AlocacaoEstatica/main/quick-install.sh | bash

echo "🚀 Instalação Rápida - WordPress no Tablet Android"
echo "=============================================="
echo ""

# Verificar se está no Termux
if [ ! -d "$PREFIX" ]; then
    echo "❌ ERRO: Execute este script no Termux!"
    echo "📱 Instale o Termux: https://f-droid.org/packages/com.termux/"
    exit 1
fi

echo "📥 Baixando scripts de instalação..."

# Criar diretório temporário
mkdir -p /tmp/wordpress-android-setup
cd /tmp/wordpress-android-setup

# Baixar arquivo de instalação principal
if command -v wget > /dev/null; then
    wget -q https://raw.githubusercontent.com/wiversonlima/AlocacaoEstatica/main/scripts/install.sh
elif command -v curl > /dev/null; then
    curl -fsSL -o install.sh https://raw.githubusercontent.com/wiversonlima/AlocacaoEstatica/main/scripts/install.sh
else
    echo "❌ wget ou curl não encontrado. Instalando..."
    pkg update -y && pkg install -y wget
    wget -q https://raw.githubusercontent.com/wiversonlima/AlocacaoEstatica/main/scripts/install.sh
fi

# Verificar se download funcionou
if [ ! -f install.sh ]; then
    echo "❌ Erro ao baixar script de instalação"
    echo "💡 Verifique sua conexão com internet"
    exit 1
fi

# Tornar executável e executar
chmod +x install.sh
echo "▶️  Iniciando instalação completa..."
./install.sh

echo ""
echo "✅ Instalação concluída!"
echo "🌐 Acesse: http://localhost:8080"
echo ""
echo "📖 Documentação completa:"
echo "   https://github.com/wiversonlima/AlocacaoEstatica"
echo ""