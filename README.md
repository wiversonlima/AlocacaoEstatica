# Servidor Local WordPress para Tablet Android

Este repositório contém instruções e scripts para configurar um servidor local de teste WordPress em tablets Android.

## Visão Geral

Configurar um servidor WordPress local em um tablet Android permite desenvolver e testar sites WordPress diretamente no dispositivo móvel, sem necessidade de conexão com internet constante.

## Pré-requisitos

- Tablet Android (versão 7.0 ou superior recomendada)
- Pelo menos 2GB de espaço livre
- Acesso root (opcional, mas recomendado para melhor performance)

## Método 1: Usando Termux (Recomendado)

### Passo 1: Instalar Termux

1. Instale o [Termux](https://f-droid.org/packages/com.termux/) da F-Droid
2. Abra o Termux e atualize os pacotes:

```bash
pkg update && pkg upgrade
```

### Passo 2: Instalar Componentes Necessários

```bash
# Instalar PHP, Apache e MariaDB
pkg install php apache2 mariadb php-apache

# Instalar utilitários necessários
pkg install wget curl unzip
```

### Passo 3: Configurar o Servidor Web

1. Configurar Apache:
```bash
# Editar configuração do Apache
nano $PREFIX/etc/apache2/httpd.conf
```

2. Adicionar suporte PHP (adicione estas linhas ao httpd.conf):
```apache
LoadModule php_module lib/php/modules/libphp.so
AddHandler php-script .php
DirectoryIndex index.html index.php
```

### Passo 4: Configurar MariaDB

```bash
# Inicializar MariaDB
mysql_install_db

# Iniciar MariaDB
mysqld_safe --datadir=$PREFIX/var/lib/mysql --socket=$PREFIX/tmp/mysql.sock &

# Configurar segurança do MySQL
mysql_secure_installation
```

### Passo 5: Baixar e Configurar WordPress

```bash
# Navegar para diretório web
cd $PREFIX/share/apache2/default-site/htdocs

# Baixar WordPress
wget https://wordpress.org/latest.zip
unzip latest.zip
mv wordpress/* .
rm -rf wordpress latest.zip

# Configurar permissões
chmod -R 755 .
```

### Passo 6: Configurar Banco de Dados WordPress

```bash
# Conectar ao MySQL
mysql -u root -p

# Criar banco de dados e usuário para WordPress
CREATE DATABASE wordpress;
CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'senha_segura';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### Passo 7: Configurar WordPress

1. Copie o arquivo de configuração:
```bash
cp wp-config-sample.php wp-config.php
nano wp-config.php
```

2. Edite as configurações do banco de dados no wp-config.php:
```php
define('DB_NAME', 'wordpress');
define('DB_USER', 'wpuser');
define('DB_PASSWORD', 'senha_segura');
define('DB_HOST', 'localhost');
```

## Método 2: Usando KSWEB

### Alternativa Mais Simples

1. Instale o [KSWEB](https://play.google.com/store/apps/details?id=ru.kslabs.ksweb) da Google Play Store
2. Configure PHP, Apache e MySQL através da interface do aplicativo
3. Baixe WordPress e extraia no diretório htdocs
4. Configure através do navegador

## Scripts de Automação

Este repositório inclui scripts para automatizar o processo de instalação.

### script_instalacao.sh

Execute este script para instalação automática:

```bash
chmod +x script_instalacao.sh
./script_instalacao.sh
```

## Iniciando o Servidor

### No Termux:

```bash
# Iniciar Apache
httpd -D FOREGROUND &

# Iniciar MySQL (se não estiver rodando)
mysqld_safe --datadir=$PREFIX/var/lib/mysql --socket=$PREFIX/tmp/mysql.sock &
```

### Acessando o WordPress

1. Abra seu navegador Android
2. Vá para: `http://localhost:8080` ou `http://127.0.0.1:8080`
3. Complete a instalação do WordPress

## Configurações Recomendadas

### Performance para Tablets

1. **Limitar uso de memória** - Adicione ao wp-config.php:
```php
define('WP_MEMORY_LIMIT', '128M');
ini_set('memory_limit', '128M');
```

2. **Cache básico** - Instale plugins de cache leves
3. **Otimizar banco de dados** - Use plugins de limpeza

### Segurança Local

1. **Mudar prefixo de tabelas** do banco de dados
2. **Senhas fortes** para usuários MySQL e WordPress
3. **Backup regular** dos dados

## Troubleshooting

### Problemas Comuns

1. **Apache não inicia**: Verifique se a porta 8080 está livre
2. **MySQL não conecta**: Verifique se o serviço está rodando
3. **PHP não funciona**: Verifique configuração do módulo PHP no Apache
4. **WordPress lento**: Reduza plugins e ajuste configurações de memória

### Logs

```bash
# Ver logs do Apache
tail -f $PREFIX/var/log/apache2/error_log

# Ver logs do MySQL
tail -f $PREFIX/var/lib/mysql/error.log
```

## Estrutura de Arquivos

```
AlocacaoEstatica/
├── README.md
├── scripts/
│   ├── install.sh
│   ├── start_server.sh
│   └── backup.sh
├── configs/
│   ├── httpd.conf
│   ├── wp-config-template.php
│   └── mysql.cnf
└── docs/
    ├── troubleshooting.md
    └── advanced-config.md
```

## Contribuindo

Sinta-se à vontade para contribuir com melhorias, correções de bugs ou novas funcionalidades.

## Licença

Este projeto está sob licença MIT - veja o arquivo LICENSE para detalhes.

## Suporte

Para dúvidas e suporte:
- Abra uma issue neste repositório
- Consulte a documentação do WordPress
- Verifique os logs de erro

---

**Nota**: Este é um ambiente de desenvolvimento local. Não use em produção sem as devidas configurações de segurança.