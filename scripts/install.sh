#!/bin/bash

# Script de Instalação Automática do WordPress no Termux
# Arquivo: install.sh

echo "=== Instalação Automática do WordPress no Termux ==="
echo "Este script irá configurar um servidor WordPress local no seu tablet Android"
echo ""

# Verificar se está rodando no Termux
if [ ! -d "$PREFIX" ]; then
    echo "ERRO: Este script deve ser executado no Termux!"
    exit 1
fi

echo "Passo 1: Atualizando pacotes do Termux..."
pkg update -y && pkg upgrade -y

echo "Passo 2: Instalando componentes necessários..."
pkg install -y php apache2 mariadb php-apache wget curl unzip nano

echo "Passo 3: Configurando Apache..."

# Backup da configuração original
cp $PREFIX/etc/apache2/httpd.conf $PREFIX/etc/apache2/httpd.conf.backup

# Configurar Apache para PHP
cat >> $PREFIX/etc/apache2/httpd.conf << 'EOF'

# Configuração PHP para WordPress
LoadModule php_module lib/php/modules/libphp.so
AddHandler php-script .php
DirectoryIndex index.html index.php

# Configurações adicionais para WordPress
<Directory "$PREFIX/share/apache2/default-site/htdocs">
    AllowOverride All
    Require all granted
</Directory>

# Porta personalizada para evitar conflitos
Listen 8080
EOF

echo "Passo 4: Configurando MariaDB..."

# Inicializar banco de dados
mysql_install_db

# Iniciar MariaDB em background
mysqld_safe --datadir=$PREFIX/var/lib/mysql --socket=$PREFIX/tmp/mysql.sock --pid-file=$PREFIX/tmp/mysql.pid &
sleep 5

# Configurar banco de dados WordPress
echo "Configurando banco de dados WordPress..."

# Gerar senha aleatória
DB_PASSWORD=$(openssl rand -base64 12)

mysql -u root << EOF
CREATE DATABASE wordpress CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'wpuser'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "Passo 5: Baixando e configurando WordPress..."

# Navegar para diretório web
cd $PREFIX/share/apache2/default-site/htdocs

# Remover arquivos padrão
rm -f index.html

# Baixar WordPress em português
wget https://br.wordpress.org/latest-pt_BR.zip -O wordpress.zip

# Extrair WordPress
unzip wordpress.zip
mv wordpress/* .
rm -rf wordpress wordpress.zip

# Configurar permissões
chmod -R 755 .
find . -type f -exec chmod 644 {} \;

echo "Passo 6: Configurando WordPress..."

# Criar wp-config.php
cat > wp-config.php << EOF
<?php
define('DB_NAME', 'wordpress');
define('DB_USER', 'wpuser');
define('DB_PASSWORD', '$DB_PASSWORD');
define('DB_HOST', 'localhost');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', 'utf8mb4_unicode_ci');

// Chaves de segurança - geradas automaticamente
define('AUTH_KEY',         '$(openssl rand -base64 32)');
define('SECURE_AUTH_KEY',  '$(openssl rand -base64 32)');
define('LOGGED_IN_KEY',    '$(openssl rand -base64 32)');
define('NONCE_KEY',        '$(openssl rand -base64 32)');
define('AUTH_SALT',        '$(openssl rand -base64 32)');
define('SECURE_AUTH_SALT', '$(openssl rand -base64 32)');
define('LOGGED_IN_SALT',   '$(openssl rand -base64 32)');
define('NONCE_SALT',       '$(openssl rand -base64 32)');

// Configurações otimizadas para tablet
define('WP_MEMORY_LIMIT', '128M');
define('WP_MAX_MEMORY_LIMIT', '256M');
define('WP_DEBUG', false);
define('AUTOMATIC_UPDATER_DISABLED', true);

\$table_prefix = 'wp_';

if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
EOF

echo "Passo 7: Criando scripts de controle..."

# Script para iniciar servidor
cat > $PREFIX/bin/wordpress-start << 'EOF'
#!/bin/bash
echo "Iniciando servidor WordPress..."
echo "Iniciando MySQL..."
if ! pgrep mysqld > /dev/null; then
    mysqld_safe --datadir=$PREFIX/var/lib/mysql --socket=$PREFIX/tmp/mysql.sock --pid-file=$PREFIX/tmp/mysql.pid &
    sleep 3
fi

echo "Iniciando Apache..."
httpd -D FOREGROUND &
APACHE_PID=$!

echo ""
echo "=========================================="
echo "Servidor WordPress iniciado com sucesso!"
echo "Acesse: http://localhost:8080"
echo "Para parar: Ctrl+C"
echo "=========================================="
echo ""

wait $APACHE_PID
EOF

chmod +x $PREFIX/bin/wordpress-start

# Script para parar servidor
cat > $PREFIX/bin/wordpress-stop << 'EOF'
#!/bin/bash
echo "Parando servidor WordPress..."
pkill httpd
pkill mysqld
echo "Servidor parado."
EOF

chmod +x $PREFIX/bin/wordpress-stop

# Salvar informações de instalação
cat > $PREFIX/etc/wordpress-info.txt << EOF
=== Informações da Instalação WordPress ===
Data da instalação: $(date)
Banco de dados: wordpress
Usuário do banco: wpuser
Senha do banco: $DB_PASSWORD
URL local: http://localhost:8080
Diretório WordPress: $PREFIX/share/apache2/default-site/htdocs
===============================================
EOF

echo ""
echo "✅ Instalação concluída com sucesso!"
echo ""
echo "📋 Informações importantes:"
echo "   - Banco de dados: wordpress"
echo "   - Usuário do banco: wpuser"
echo "   - Senha do banco: $DB_PASSWORD"
echo ""
echo "🚀 Para iniciar o servidor:"
echo "   wordpress-start"
echo ""
echo "🛑 Para parar o servidor:"
echo "   wordpress-stop"
echo ""
echo "🌐 Acesse no navegador:"
echo "   http://localhost:8080"
echo ""
echo "📝 Informações salvas em: $PREFIX/etc/wordpress-info.txt"
echo ""
echo "⚠️  IMPORTANTE: Anote a senha do banco de dados!"