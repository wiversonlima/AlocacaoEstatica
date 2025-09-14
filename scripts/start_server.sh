#!/bin/bash

# Script para iniciar o servidor WordPress
# Arquivo: start_server.sh

echo "🚀 Iniciando Servidor Local WordPress..."

# Verificar se está no Termux
if [ ! -d "$PREFIX" ]; then
    echo "❌ ERRO: Este script deve ser executado no Termux!"
    exit 1
fi

# Verificar se WordPress está instalado
if [ ! -f "$PREFIX/share/apache2/default-site/htdocs/wp-config.php" ]; then
    echo "❌ WordPress não encontrado!"
    echo "Execute primeiro: ./install.sh"
    exit 1
fi

echo "📊 Verificando serviços..."

# Função para verificar se uma porta está em uso
check_port() {
    netstat -tuln 2>/dev/null | grep ":$1 " > /dev/null
    return $?
}

# Verificar porta 8080
if check_port 8080; then
    echo "⚠️  Porta 8080 já está em uso. Tentando parar serviços..."
    pkill httpd 2>/dev/null
    sleep 2
fi

# Iniciar MySQL se não estiver rodando
if ! pgrep mysqld > /dev/null; then
    echo "🗄️  Iniciando MySQL..."
    mysqld_safe --datadir=$PREFIX/var/lib/mysql --socket=$PREFIX/tmp/mysql.sock --pid-file=$PREFIX/tmp/mysql.pid > /dev/null 2>&1 &
    
    # Aguardar MySQL inicializar
    echo "⏳ Aguardando MySQL inicializar..."
    for i in {1..30}; do
        if mysqladmin ping --socket=$PREFIX/tmp/mysql.sock --silent 2>/dev/null; then
            echo "✅ MySQL iniciado com sucesso!"
            break
        fi
        sleep 1
        if [ $i -eq 30 ]; then
            echo "❌ Timeout: MySQL não conseguiu inicializar"
            exit 1
        fi
    done
else
    echo "✅ MySQL já está rodando"
fi

# Verificar conectividade do banco
echo "🔍 Testando conexão com banco de dados..."
if ! mysql -u wpuser --socket=$PREFIX/tmp/mysql.sock -e "USE wordpress;" 2>/dev/null; then
    echo "❌ Erro: Não foi possível conectar ao banco WordPress"
    echo "💡 Tente reinstalar com: ./install.sh"
    exit 1
fi

echo "✅ Banco de dados OK"

# Iniciar Apache
echo "🌐 Iniciando Apache..."

# Configurar variáveis de ambiente para Apache
export APACHE_PID_FILE=$PREFIX/tmp/httpd.pid
export APACHE_LOCK_DIR=$PREFIX/tmp
export APACHE_LOG_DIR=$PREFIX/var/log/apache2

# Criar diretórios necessários
mkdir -p $PREFIX/var/log/apache2 $PREFIX/tmp

# Verificar configuração do Apache
if ! httpd -t -f $PREFIX/etc/apache2/httpd.conf 2>/dev/null; then
    echo "❌ Erro na configuração do Apache"
    echo "💡 Verifique: $PREFIX/etc/apache2/httpd.conf"
    exit 1
fi

# Iniciar Apache
httpd -D FOREGROUND -f $PREFIX/etc/apache2/httpd.conf &
APACHE_PID=$!

# Aguardar Apache inicializar
echo "⏳ Aguardando Apache inicializar..."
sleep 3

# Verificar se Apache iniciou
if ! ps -p $APACHE_PID > /dev/null 2>&1; then
    echo "❌ Falha ao iniciar Apache"
    echo "📋 Verificando logs..."
    tail -10 $PREFIX/var/log/apache2/error_log 2>/dev/null || echo "Logs não disponíveis"
    exit 1
fi

# Testar conectividade
if check_port 8080; then
    echo "✅ Apache iniciado com sucesso!"
else
    echo "❌ Apache não está respondendo na porta 8080"
    exit 1
fi

# Mostrar informações de acesso
echo ""
echo "🎉 =========================================="
echo "   Servidor WordPress iniciado com sucesso!"
echo "=========================================="
echo ""
echo "🌐 Acesse no navegador do tablet:"
echo "   http://localhost:8080"
echo "   http://127.0.0.1:8080"
echo ""
echo "📱 Para acessar de outros dispositivos na rede:"
echo "   Descubra o IP do tablet: ip addr show"
echo "   Acesse: http://[IP-DO-TABLET]:8080"
echo ""
echo "🛑 Para parar o servidor:"
echo "   Pressione Ctrl+C ou execute:"
echo "   wordpress-stop"
echo ""
echo "📊 Status dos serviços:"
echo "   ✅ MySQL: Rodando"
echo "   ✅ Apache: Rodando na porta 8080"
echo "   ✅ WordPress: Disponível"
echo ""
echo "📋 Logs em tempo real:"
echo "   Acesse outro terminal e execute:"
echo "   tail -f $PREFIX/var/log/apache2/access_log"
echo "   tail -f $PREFIX/var/log/apache2/error_log"
echo ""

# Criar arquivo de status
cat > $PREFIX/tmp/wordpress-status << EOF
RUNNING
Started: $(date)
PID_Apache: $APACHE_PID
PID_MySQL: $(pgrep mysqld)
URL: http://localhost:8080
EOF

# Função para limpeza ao sair
cleanup() {
    echo ""
    echo "🛑 Parando servidor WordPress..."
    kill $APACHE_PID 2>/dev/null
    pkill mysqld 2>/dev/null
    rm -f $PREFIX/tmp/wordpress-status
    echo "✅ Servidor parado"
    exit 0
}

# Capturar sinais de interrupção
trap cleanup SIGINT SIGTERM

# Manter o script rodando e monitorar os serviços
while true; do
    # Verificar se Apache ainda está rodando
    if ! ps -p $APACHE_PID > /dev/null 2>&1; then
        echo "❌ Apache parou inesperadamente"
        cleanup
    fi
    
    # Verificar se MySQL ainda está rodando
    if ! pgrep mysqld > /dev/null; then
        echo "❌ MySQL parou inesperadamente"
        cleanup
    fi
    
    sleep 10
done