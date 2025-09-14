# Guia de Solução de Problemas - WordPress no Android

## Problemas Comuns e Soluções

### 1. Apache não inicia

**Sintomas:**
- Erro "Address already in use" na porta 8080
- Apache para imediatamente após iniciar
- Não consegue acessar http://localhost:8080

**Soluções:**

```bash
# Verificar se a porta está em uso
netstat -tuln | grep :8080

# Parar processos que estão usando a porta
pkill httpd
pkill apache2

# Verificar configuração do Apache
httpd -t -f $PREFIX/etc/apache2/httpd.conf

# Ver logs de erro
tail -f $PREFIX/var/log/apache2/error_log
```

**Configurações alternativas:**
- Mudar porta no httpd.conf de 8080 para 8081, 8082, etc.
- Verificar se outro app está usando a porta (alguns navegadores, servidores de desenvolvimento)

### 2. MySQL não conecta

**Sintomas:**
- Erro "Can't connect to MySQL server"
- WordPress mostra erro de conexão com banco
- Comando mysql retorna erro

**Soluções:**

```bash
# Verificar se MySQL está rodando
pgrep mysqld

# Iniciar MySQL manualmente
mysqld_safe --datadir=$PREFIX/var/lib/mysql --socket=$PREFIX/tmp/mysql.sock --pid-file=$PREFIX/tmp/mysql.pid &

# Testar conexão
mysql -u root --socket=$PREFIX/tmp/mysql.sock

# Verificar logs do MySQL
tail -f $PREFIX/var/lib/mysql/error.log

# Reparar tabelas se necessário
mysql_upgrade --socket=$PREFIX/tmp/mysql.sock
```

**Reset completo do MySQL:**
```bash
# CUIDADO: Isso apaga todos os dados!
pkill mysqld
rm -rf $PREFIX/var/lib/mysql/*
mysql_install_db
# Recriar banco WordPress
```

### 3. PHP não funciona

**Sintomas:**
- Páginas PHP são baixadas em vez de executadas
- Erro "No input file specified"
- WordPress mostra código PHP na tela

**Soluções:**

```bash
# Verificar se módulo PHP está carregado
httpd -M | grep php

# Testar PHP isoladamente
php -v
php -m | grep mysql

# Verificar configuração no httpd.conf
grep -n "php" $PREFIX/etc/apache2/httpd.conf
```

**Adicionar ao httpd.conf se necessário:**
```apache
LoadModule php_module lib/php/modules/libphp.so
AddHandler php-script .php
AddType application/x-httpd-php .php
```

### 4. WordPress lento

**Sintomas:**
- Páginas demoram muito para carregar
- Admin do WordPress trava
- Timeout ao fazer operações

**Soluções:**

```bash
# Aumentar limites no wp-config.php
ini_set('memory_limit', '256M');
ini_set('max_execution_time', 120);

# Otimizar MySQL
mysql -u root -e "OPTIMIZE TABLE wp_posts, wp_options, wp_postmeta;"

# Limpar cache do WordPress
rm -rf wp-content/cache/*

# Desabilitar plugins pesados
```

**Plugins recomendados para otimização:**
- WP Rocket (cache)
- Autoptimize (otimização CSS/JS)
- WP-Optimize (limpeza banco)

### 5. Erro de permissões

**Sintomas:**
- Não consegue instalar temas/plugins
- Erro "Unable to create directory"
- Uploads não funcionam

**Soluções:**

```bash
# Corrigir permissões WordPress
cd $PREFIX/share/apache2/default-site/htdocs
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;
chmod 600 wp-config.php

# Verificar dono dos arquivos
ls -la wp-content/

# Configurar no wp-config.php
define('FS_METHOD', 'direct');
```

### 6. Termux fecha inesperadamente

**Sintomas:**
- Aplicativo Termux fecha sozinho
- Servidor para quando tablet entra em suspensão
- Processos são mortos pelo Android

**Soluções:**

```bash
# Configurar Termux para não hibernar
# Ir em Configurações > Aplicativos > Termux > Bateria > Otimização = Desabilitada

# Usar Termux:Boot para auto-iniciar
pkg install termux-services

# Criar serviço persistente
echo '#!/bin/bash
wordpress-start' > ~/.termux/boot/start-wordpress
chmod +x ~/.termux/boot/start-wordpress

# Usar wake lock
termux-wake-lock
```

### 7. Problemas de rede

**Sintomas:**
- Não consegue acessar de outros dispositivos
- Conexão intermitente
- DNS não resolve

**Soluções:**

```bash
# Descobrir IP do tablet
ip addr show wlan0 | grep inet

# Testar conectividade
ping 8.8.8.8

# Configurar firewall (se necessário)
# Geralmente Android não precisa

# Verificar se router permite acesso entre dispositivos
```

### 8. Banco de dados corrompido

**Sintomas:**
- WordPress mostra "Error establishing database connection"
- Tabelas não existem
- Dados perdidos

**Soluções:**

```bash
# Verificar integridade
mysqlcheck -u wpuser -p wordpress --check

# Reparar tabelas
mysqlcheck -u wpuser -p wordpress --repair

# Restaurar do backup
mysql -u wpuser -p wordpress < backup.sql

# WordPress repair mode
# Adicionar ao wp-config.php:
define('WP_ALLOW_REPAIR', true);
# Acessar: http://localhost:8080/wp-admin/maint/repair.php
```

### 9. Memória insuficiente

**Sintomas:**
- "Fatal error: Out of memory"
- Tablet fica lento
- Apps fecham sozinhos

**Soluções:**

```bash
# Reduzir uso de memória no wp-config.php
define('WP_MEMORY_LIMIT', '64M');
ini_set('memory_limit', '64M');

# Otimizar MySQL
# Reduzir innodb_buffer_pool_size no mysql.cnf

# Fechar apps desnecessários
# Usar limpador de RAM

# Configurar swap (se possível)
```

### 10. SSL/HTTPS problemas

**Sintomas:**
- Mixed content warnings
- Certificados inválidos
- Redirecionamentos incorretos

**Soluções:**

```bash
# Para ambiente local, usar HTTP
# No wp-config.php:
define('FORCE_SSL_ADMIN', false);

# Corrigir URLs
mysql -u wpuser -p wordpress -e "
UPDATE wp_options SET option_value = 'http://localhost:8080' WHERE option_name = 'home';
UPDATE wp_options SET option_value = 'http://localhost:8080' WHERE option_name = 'siteurl';
"
```

## Comandos Úteis para Diagnóstico

```bash
# Status geral do sistema
free -h                    # Uso de memória
df -h                      # Uso de disco
ps aux | grep -E "(httpd|mysqld|php)"  # Processos rodando

# Logs importantes
tail -f $PREFIX/var/log/apache2/error_log
tail -f $PREFIX/var/log/apache2/access_log
tail -f $PREFIX/var/lib/mysql/error.log

# Teste de conectividade
curl -I http://localhost:8080
telnet localhost 8080

# Informações PHP
php -i | grep -E "(memory_limit|max_execution_time)"

# Status MySQL
mysqladmin --socket=$PREFIX/tmp/mysql.sock status
```

## Quando Pedir Ajuda

Se os problemas persistirem:

1. **Colete informações:**
   - Versão do Android
   - Modelo do tablet
   - RAM disponível
   - Logs de erro

2. **Abra uma issue incluindo:**
   - Descrição detalhada do problema
   - Passos para reproduzir
   - Logs relevantes
   - Configuração do sistema

3. **Teste em modo seguro:**
   - Desabilite todos os plugins
   - Use tema padrão
   - Verifique se o problema persiste