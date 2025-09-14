# Configurações Avançadas - WordPress no Android

## Performance Avançada

### Otimização do MySQL para SSD/eMMC

A maioria dos tablets Android usa armazenamento eMMC ou UFS, que tem características diferentes de HDDs tradicionais:

```sql
-- Configurações específicas para storage flash
SET GLOBAL innodb_flush_method = 'O_DIRECT';
SET GLOBAL innodb_io_capacity = 500;
SET GLOBAL innodb_io_capacity_max = 1000;
SET GLOBAL innodb_flush_neighbors = 0;
```

### Configuração de Cache Agressivo

**wp-config.php otimizado:**

```php
// Cache de objetos em memória
define('WP_CACHE', true);
define('WP_CACHE_KEY_SALT', 'android_tablet_');

// Cache de banco de dados
define('DB_CACHE_TIMEOUT', 3600);
define('DB_CACHE_ROWS', 10000);

// Otimizações de autoload
define('WP_AUTO_UPDATE_CORE', false);
define('AUTOMATIC_UPDATER_DISABLED', true);

// Compressão de saída
ini_set('zlib.output_compression', 'On');
ini_set('zlib.output_compression_level', 6);
```

### PHP-FPM vs mod_php

Para melhor performance em tablets com recursos limitados:

```bash
# Instalar PHP-FPM (alternativo)
pkg install php-fpm

# Configurar Apache para usar PHP-FPM
# No httpd.conf, substituir mod_php por:
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so

<FilesMatch \.php$>
    SetHandler "proxy:fcgi://127.0.0.1:9000"
</FilesMatch>
```

## Configurações de Rede Avançadas

### Servidor Acessível na Rede Local

**Configurar Apache para aceitar conexões externas:**

```apache
# httpd.conf
Listen 0.0.0.0:8080

<VirtualHost *:8080>
    DocumentRoot /data/data/com.termux/files/usr/share/apache2/default-site/htdocs
    ServerName tablet.local
    
    <Directory "/data/data/com.termux/files/usr/share/apache2/default-site/htdocs">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

**WordPress Multi-Device Setup:**

```php
// wp-config.php - URLs dinâmicas
$protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? 'https' : 'http';
$host = $_SERVER['HTTP_HOST'];
define('WP_HOME', $protocol . '://' . $host);
define('WP_SITEURL', $protocol . '://' . $host);

// Cookie domain dinâmico
define('COOKIE_DOMAIN', '.' . preg_replace('/^www\./', '', $_SERVER['HTTP_HOST']));
```

### Configuração de DNS Local

**Usando dnsmasq no tablet:**

```bash
pkg install dnsmasq

# Configurar dnsmasq
echo "address=/tablet.local/192.168.1.100" > $PREFIX/etc/dnsmasq.conf
echo "listen-address=127.0.0.1" >> $PREFIX/etc/dnsmasq.conf

# Iniciar dnsmasq
dnsmasq -C $PREFIX/etc/dnsmasq.conf
```

## Segurança Avançada

### Configuração de Firewall

```bash
# Usando iptables (requer root)
iptables -A INPUT -p tcp --dport 8080 -s 192.168.1.0/24 -j ACCEPT
iptables -A INPUT -p tcp --dport 8080 -j DROP

# Salvar regras
iptables-save > $PREFIX/etc/iptables.rules
```

### Autenticação HTTP

**Proteger admin com HTTP Auth:**

```apache
# .htaccess no wp-admin
<Files admin-ajax.php>
    Order allow,deny
    Allow from all
    Satisfy any
</Files>

AuthType Basic
AuthName "WordPress Admin"
AuthUserFile /data/data/com.termux/files/usr/etc/.htpasswd
Require valid-user
```

```bash
# Criar arquivo de senhas
htpasswd -c $PREFIX/etc/.htpasswd admin
```

### SSL/TLS Local

**Gerar certificado auto-assinado:**

```bash
# Instalar OpenSSL
pkg install openssl

# Gerar certificado
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout $PREFIX/etc/ssl/tablet.key \
    -out $PREFIX/etc/ssl/tablet.crt \
    -subj "/C=BR/ST=SP/L=SaoPaulo/O=TabletWP/CN=tablet.local"

# Configurar HTTPS no Apache
echo "LoadModule ssl_module modules/mod_ssl.so
Listen 8443 ssl

<VirtualHost *:8443>
    SSLEngine on
    SSLCertificateFile $PREFIX/etc/ssl/tablet.crt
    SSLCertificateKeyFile $PREFIX/etc/ssl/tablet.key
    DocumentRoot $PREFIX/share/apache2/default-site/htdocs
</VirtualHost>" >> $PREFIX/etc/apache2/httpd.conf
```

## Monitoramento e Logs

### Sistema de Monitoramento

**Script de monitoramento automático:**

```bash
#!/bin/bash
# monitor.sh

LOG_FILE="$PREFIX/var/log/wordpress-monitor.log"

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    
    # CPU e Memória
    CPU=$(top -n1 | grep "CPU:" | awk '{print $2}' | sed 's/%//')
    MEM=$(free | grep Mem | awk '{printf "%.1f", $3/$2 * 100.0}')
    
    # Status dos serviços
    APACHE_STATUS=$(pgrep httpd > /dev/null && echo "UP" || echo "DOWN")
    MYSQL_STATUS=$(pgrep mysqld > /dev/null && echo "UP" || echo "DOWN")
    
    # Espaço em disco
    DISK_USAGE=$(df $PREFIX | tail -1 | awk '{print $5}' | sed 's/%//')
    
    # Log
    echo "[$TIMESTAMP] CPU:${CPU}% MEM:${MEM}% DISK:${DISK_USAGE}% APACHE:$APACHE_STATUS MYSQL:$MYSQL_STATUS" >> $LOG_FILE
    
    # Alertas
    if [[ $MEM > 80 ]]; then
        echo "⚠️  Alta utilização de memória: ${MEM}%"
    fi
    
    if [[ $DISK_USAGE > 90 ]]; then
        echo "⚠️  Pouco espaço em disco: ${DISK_USAGE}%"
    fi
    
    sleep 300  # 5 minutos
done
```

### Rotação de Logs

```bash
# logrotate.conf
$PREFIX/var/log/apache2/*.log {
    daily
    missingok
    rotate 7
    compress
    notifempty
    create 644 root root
    postrotate
        pkill -USR1 httpd
    endscript
}

$PREFIX/var/lib/mysql/*.log {
    daily
    missingok
    rotate 14
    compress
    notifempty
    create 644 root root
    postrotate
        mysqladmin --socket=$PREFIX/tmp/mysql.sock flush-logs
    endscript
}
```

## Backup Avançado

### Backup Incremental

```bash
#!/bin/bash
# backup-incremental.sh

BACKUP_BASE="$HOME/wordpress-backups"
LAST_BACKUP="$BACKUP_BASE/.last-backup"
WP_DIR="$PREFIX/share/apache2/default-site/htdocs"

# Criar backup incremental baseado na data do último backup
if [[ -f $LAST_BACKUP ]]; then
    REFERENCE_DATE=$(cat $LAST_BACKUP)
    find $WP_DIR -newer $REFERENCE_DATE -type f | \
        tar -czf "$BACKUP_BASE/incremental-$(date +%Y%m%d_%H%M%S).tar.gz" -T -
else
    # Primeiro backup completo
    tar -czf "$BACKUP_BASE/full-$(date +%Y%m%d_%H%M%S).tar.gz" -C $WP_DIR .
fi

# Atualizar referência
date > $LAST_BACKUP
```

### Sincronização com Cloud

```bash
# Usando rclone para sync com Google Drive/Dropbox
pkg install rclone

# Configurar rclone
rclone config

# Sync automático
rclone sync $HOME/wordpress-backups/ remote:wordpress-backups/
```

## Desenvolvimento e Debug

### Profiling de Performance

```php
// wp-config.php - Profiling
define('SAVEQUERIES', true);
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('SCRIPT_DEBUG', true);

// Query Monitor plugin recomendado para análise detalhada
```

### Debug Avançado

```php
// Debug específico para tablet
if (isset($_GET['debug']) && $_GET['debug'] === 'tablet') {
    ini_set('display_errors', 1);
    error_reporting(E_ALL);
    
    // Log de informações do sistema
    $system_info = [
        'PHP Version' => phpversion(),
        'Memory Limit' => ini_get('memory_limit'),
        'Max Execution Time' => ini_get('max_execution_time'),
        'Available Memory' => round(memory_get_usage(true) / 1024 / 1024, 2) . ' MB',
        'Peak Memory' => round(memory_get_peak_usage(true) / 1024 / 1024, 2) . ' MB'
    ];
    
    error_log('System Info: ' . json_encode($system_info));
}
```

### Ferramentas de Desenvolvimento

```bash
# Instalar ferramentas úteis
pkg install git vim tree htop

# MySQL Workbench alternativo
pkg install mycli

# Conectar com interface melhorada
mycli -u wpuser -p --socket=$PREFIX/tmp/mysql.sock wordpress
```

## Automação e Scripts

### Cron Jobs no Android

```bash
# Instalar cron
pkg install cronie

# Configurar crontab
crontab -e

# Exemplos de tarefas:
# Backup diário às 3:00
0 3 * * * $HOME/scripts/backup.sh

# Limpeza de logs semanalmente
0 1 * * 0 find $PREFIX/var/log -name "*.log" -mtime +7 -delete

# Otimização do banco mensalmente
0 2 1 * * mysqlcheck -u wpuser -p$(grep DB_PASSWORD wp-config.php | cut -d"'" -f4) --optimize wordpress
```

### Startup Scripts

```bash
# ~/.termux/boot/wordpress-autostart
#!/bin/bash

# Aguardar sistema estabilizar
sleep 30

# Iniciar serviços
if [[ ! -f $PREFIX/tmp/wordpress-started ]]; then
    wordpress-start > /dev/null 2>&1 &
    touch $PREFIX/tmp/wordpress-started
fi
```

## Otimizações Específicas do Android

### Gerenciamento de Bateria

```bash
# Configurações para economizar bateria
echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# Reduzir frequency de logs
echo "kernel.printk = 3 4 1 3" > /proc/sys/kernel/printk
```

### Configurações de Rede

```bash
# Otimizar TCP para redes móveis
echo 'net.ipv4.tcp_congestion_control = bbr' >> /proc/sys/net/ipv4/tcp_congestion_control
echo 'net.core.default_qdisc = fq' >> /proc/sys/net/core/default_qdisc
```

Esta configuração avançada permite extrair o máximo de performance do servidor WordPress em tablets Android, mantendo estabilidade e segurança adequadas para ambiente de desenvolvimento.