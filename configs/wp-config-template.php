<?php
/**
 * Template de configuração WordPress otimizado para tablet Android
 * Arquivo: wp-config-template.php
 * 
 * Copie este arquivo para wp-config.php e ajuste as configurações
 */

// ** Configurações do banco de dados ** //
define('DB_NAME', 'wordpress');
define('DB_USER', 'wpuser');
define('DB_PASSWORD', 'SUBSTITUA_PELA_SENHA_GERADA');
define('DB_HOST', 'localhost');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', 'utf8mb4_unicode_ci');

/**
 * Chaves de autenticação e salts únicos.
 * Gere novas chaves em: https://api.wordpress.org/secret-key/1.1/salt/
 */
define('AUTH_KEY',         'SUBSTITUA_POR_CHAVE_UNICA');
define('SECURE_AUTH_KEY',  'SUBSTITUA_POR_CHAVE_UNICA');
define('LOGGED_IN_KEY',    'SUBSTITUA_POR_CHAVE_UNICA');
define('NONCE_KEY',        'SUBSTITUA_POR_CHAVE_UNICA');
define('AUTH_SALT',        'SUBSTITUA_POR_CHAVE_UNICA');
define('SECURE_AUTH_SALT', 'SUBSTITUA_POR_CHAVE_UNICA');
define('LOGGED_IN_SALT',   'SUBSTITUA_POR_CHAVE_UNICA');
define('NONCE_SALT',       'SUBSTITUA_POR_CHAVE_UNICA');

/**
 * Configurações otimizadas para tablet Android
 */

// Limite de memória - ajustado para dispositivos móveis
define('WP_MEMORY_LIMIT', '128M');
define('WP_MAX_MEMORY_LIMIT', '256M');

// Configurações de cache e performance
define('WP_CACHE', true);
define('COMPRESS_CSS', true);
define('COMPRESS_SCRIPTS', true);
define('CONCATENATE_SCRIPTS', false); // Pode causar problemas em alguns tablets

// Configurações de segurança
define('DISALLOW_FILE_EDIT', true);
define('DISALLOW_FILE_MODS', false); // Permitir instalação de plugins
define('FORCE_SSL_ADMIN', false); // Para ambiente local
define('WP_DEBUG', false);
define('WP_DEBUG_LOG', false);
define('WP_DEBUG_DISPLAY', false);

// Configurações de atualização
define('AUTOMATIC_UPDATER_DISABLED', true); // Desabilitar atualizações automáticas
define('WP_AUTO_UPDATE_CORE', false);

// Configurações de upload otimizadas para tablet
ini_set('upload_max_filesize', '32M');
ini_set('post_max_size', '32M');
ini_set('max_execution_time', 60);
ini_set('max_input_vars', 3000);

// Configurações de sessão
ini_set('session.gc_maxlifetime', 1440);
ini_set('session.cookie_lifetime', 1440);

// Configurações de banco de dados otimizadas
define('WP_ALLOW_REPAIR', false);
define('DB_REPAIR', false);

// Configurações de media
define('IMAGE_EDIT_OVERWRITE', true);
define('MEDIA_TRASH', true);

// Configurações de cron
define('DISABLE_WP_CRON', false);
define('WP_CRON_LOCK_TIMEOUT', 60);

// Configurações de HTTP
define('WP_HTTP_BLOCK_EXTERNAL', false);
define('WP_ACCESSIBLE_HOSTS', 'api.wordpress.org,*.github.com');

// Configurações de filesystem
define('FS_METHOD', 'direct');
define('FS_CHMOD_DIR', (0755 & ~ umask()));
define('FS_CHMOD_FILE', (0644 & ~ umask()));

// Configurações de multisite (desabilitado por padrão)
// define('WP_ALLOW_MULTISITE', false);

// URL específicas para ambiente local
// define('WP_HOME', 'http://localhost:8080');
// define('WP_SITEURL', 'http://localhost:8080');

// Configurações de cookies para ambiente local
// define('COOKIE_DOMAIN', 'localhost');

/**
 * Configurações específicas para desenvolvimento em tablet
 */

// Desabilitar plugins problemáticos automaticamente
if (!defined('WP_CLI') && !is_admin()) {
    // Lista de plugins que podem causar problemas em tablets
    $problematic_plugins = array(
        'w3-total-cache/w3-total-cache.php',
        'wp-super-cache/wp-cache.php'
    );
    
    foreach ($problematic_plugins as $plugin) {
        if (is_plugin_active($plugin)) {
            deactivate_plugins($plugin);
        }
    }
}

// Configurações de log personalizadas
if (WP_DEBUG) {
    define('WP_DEBUG_LOG', true);
    define('WP_DEBUG_DISPLAY', false);
    @ini_set('log_errors', 'On');
    @ini_set('error_log', '/data/data/com.termux/files/usr/var/log/wordpress-debug.log');
}

// Otimizações para tablet Android
add_action('init', function() {
    // Reduzir consumo de memória
    @ini_set('memory_limit', WP_MEMORY_LIMIT);
    
    // Otimizar garbage collection
    if (function_exists('gc_enable')) {
        gc_enable();
    }
});

// Desabilitar recursos pesados em tablets
add_action('wp_loaded', function() {
    // Desabilitar embeds se não necessário
    remove_action('wp_head', 'wp_oembed_add_discovery_links');
    remove_action('wp_head', 'wp_oembed_add_host_js');
    
    // Remover scripts desnecessários
    remove_action('wp_head', 'print_emoji_detection_script', 7);
    remove_action('wp_print_styles', 'print_emoji_styles');
    
    // Desabilitar XML-RPC se não usar
    add_filter('xmlrpc_enabled', '__return_false');
});

/**
 * Prefixo das tabelas do banco de dados
 */
$table_prefix = 'wp_';

/**
 * Idioma do WordPress
 */
define('WPLANG', 'pt_BR');

/**
 * Não edite a partir daqui
 */
if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';