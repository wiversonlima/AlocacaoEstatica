#!/bin/bash

# Script para demonstrar o programa de mapas
echo "========================================"
echo "DEMONSTRAÇÃO: CONSTRUÇÃO DE MAPAS"
echo "========================================"
echo

# Compila o programa
echo "Compilando o programa..."
cd AlocacaoEstatica
g++ -o mapas Estatica.cpp -std=c++11

if [ $? -eq 0 ]; then
    echo "✓ Compilação bem-sucedida!"
    echo
    
    echo "Executando demonstração..."
    echo "Pressione Enter quando solicitado para ver todos os mapas."
    echo
    
    # Executa o programa
    echo "" | ./mapas
    
    echo
    echo "✓ Demonstração concluída!"
    echo
    echo "Arquivos criados:"
    echo "- Estatica.cpp (código fonte principal)"
    echo "- README.md (documentação completa)"
    echo "- EXEMPLOS.md (exemplos de uso)"
    echo
    echo "Para usar em seu próprio projeto:"
    echo "1. Copie o arquivo Estatica.cpp"
    echo "2. Inclua as funções necessárias"
    echo "3. Compile com: g++ -o seu_programa seu_codigo.cpp -std=c++11"
    
else
    echo "✗ Erro na compilação!"
    exit 1
fi