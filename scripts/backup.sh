#!/bin/bash

# Script de backup do WordPress
# Arquivo: backup.sh

echo "💾 Script de Backup WordPress"

# Verificar se está no Termux
if [ ! -d "$PREFIX" ]; then
    echo "❌ ERRO: Este script deve ser executado no Termux!"
    exit 1
fi

# Configurações
BACKUP_DIR="$HOME/wordpress-backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="wordpress_backup_$TIMESTAMP"
WP_DIR="$PREFIX/share/apache2/default-site/htdocs"

# Criar diretório de backup se não existir
mkdir -p "$BACKUP_DIR"

echo "📂 Criando backup em: $BACKUP_DIR/$BACKUP_NAME"

# Verificar se WordPress existe
if [ ! -f "$WP_DIR/wp-config.php" ]; then
    echo "❌ WordPress não encontrado em $WP_DIR"
    exit 1
fi

# Criar diretório do backup
mkdir -p "$BACKUP_DIR/$BACKUP_NAME"

echo "📁 Fazendo backup dos arquivos WordPress..."

# Backup dos arquivos WordPress
tar -czf "$BACKUP_DIR/$BACKUP_NAME/wordpress_files.tar.gz" -C "$WP_DIR" . 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Backup dos arquivos concluído"
    FILE_SIZE=$(du -h "$BACKUP_DIR/$BACKUP_NAME/wordpress_files.tar.gz" | cut -f1)
    echo "   Tamanho: $FILE_SIZE"
else
    echo "❌ Erro no backup dos arquivos"
    exit 1
fi

echo "🗄️  Fazendo backup do banco de dados..."

# Verificar se MySQL está rodando
if ! pgrep mysqld > /dev/null; then
    echo "⚠️  MySQL não está rodando. Iniciando..."
    mysqld_safe --datadir=$PREFIX/var/lib/mysql --socket=$PREFIX/tmp/mysql.sock --pid-file=$PREFIX/tmp/mysql.pid > /dev/null 2>&1 &
    sleep 5
fi

# Extrair credenciais do wp-config.php
DB_NAME=$(grep "DB_NAME" "$WP_DIR/wp-config.php" | cut -d "'" -f 4)
DB_USER=$(grep "DB_USER" "$WP_DIR/wp-config.php" | cut -d "'" -f 4)
DB_PASS=$(grep "DB_PASSWORD" "$WP_DIR/wp-config.php" | cut -d "'" -f 4)

# Backup do banco de dados
mysqldump --socket=$PREFIX/tmp/mysql.sock -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$BACKUP_DIR/$BACKUP_NAME/database.sql" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Backup do banco de dados concluído"
    DB_SIZE=$(du -h "$BACKUP_DIR/$BACKUP_NAME/database.sql" | cut -f1)
    echo "   Tamanho: $DB_SIZE"
else
    echo "❌ Erro no backup do banco de dados"
    echo "💡 Verifique as credenciais no wp-config.php"
fi

# Criar arquivo de informações do backup
cat > "$BACKUP_DIR/$BACKUP_NAME/backup_info.txt" << EOF
=== Informações do Backup WordPress ===
Data: $(date)
Versão WordPress: $(grep wp_version "$WP_DIR/wp-includes/version.php" | cut -d "'" -f 2 2>/dev/null || echo "Desconhecida")
Banco de dados: $DB_NAME
Usuário do banco: $DB_USER
Diretório WordPress: $WP_DIR
Arquivos incluídos: wordpress_files.tar.gz
Banco incluído: database.sql
========================================
EOF

# Criar arquivo com instruções de restauração
cat > "$BACKUP_DIR/$BACKUP_NAME/COMO_RESTAURAR.txt" << 'EOF'
=== Como Restaurar este Backup ===

1. Parar o servidor WordPress:
   wordpress-stop

2. Fazer backup atual (opcional):
   ./backup.sh

3. Restaurar arquivos:
   cd $PREFIX/share/apache2/default-site/htdocs
   rm -rf * .*  # CUIDADO: Remove tudo!
   tar -xzf /caminho/para/wordpress_files.tar.gz

4. Restaurar banco de dados:
   mysql -u wpuser -p wordpress < /caminho/para/database.sql

5. Iniciar servidor:
   wordpress-start

IMPORTANTE:
- Substitua "/caminho/para/" pelo caminho real do backup
- Certifique-se de que as credenciais do banco estão corretas
- Teste o site após a restauração
=====================================
EOF

# Compactar todo o backup
echo "🗜️  Compactando backup completo..."
cd "$BACKUP_DIR"
tar -czf "${BACKUP_NAME}.tar.gz" "$BACKUP_NAME" 2>/dev/null

if [ $? -eq 0 ]; then
    # Remover diretório temporário
    rm -rf "$BACKUP_NAME"
    
    TOTAL_SIZE=$(du -h "${BACKUP_NAME}.tar.gz" | cut -f1)
    echo "✅ Backup completo criado: ${BACKUP_NAME}.tar.gz"
    echo "   Tamanho total: $TOTAL_SIZE"
else
    echo "⚠️  Erro ao compactar, mas arquivos estão disponíveis em: $BACKUP_DIR/$BACKUP_NAME"
fi

echo ""
echo "🎉 ========================================="
echo "   Backup concluído com sucesso!"
echo "========================================"
echo ""
echo "📂 Localização: $BACKUP_DIR"
echo "📦 Arquivo: ${BACKUP_NAME}.tar.gz"
echo ""
echo "💡 Dicas:"
echo "   - Copie o backup para armazenamento externo"
echo "   - Teste a restauração periodicamente"
echo "   - Mantenha vários backups por segurança"
echo ""

# Listar backups existentes
echo "📋 Backups existentes:"
ls -lh "$BACKUP_DIR"/*.tar.gz 2>/dev/null | awk '{print "   " $9 " (" $5 ")"}'

echo ""
echo "🗑️  Para limpar backups antigos:"
echo "   find $BACKUP_DIR -name '*.tar.gz' -mtime +30 -delete"
echo ""