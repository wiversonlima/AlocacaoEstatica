# Monitoramento Persistente - Android Monitoring Application

Este é um aplicativo Android para monitoramento do sistema com instalação persistente.

## Funcionalidades

### Monitoramento
- Coleta de informações do sistema (CPU, memória, bateria)
- Log em tempo real das atividades
- Execução em segundo plano (foreground service)

### Persistência
- Administrador de dispositivo para proteção contra desinstalação
- Reinicialização automática após boot
- Serviço de keep-alive para manter os componentes ativos
- Proteção contra término de processos

## Componentes Principais

### MainActivity
Interface principal para controle do aplicativo:
- Ativação/desativação do administrador de dispositivo
- Controle do monitoramento
- Visualização de logs em tempo real

### DeviceAdminReceiver
Receptor de administrador de dispositivo que:
- Protege o aplicativo contra desinstalação
- Ativa serviços de proteção quando habilitado

### MonitoringService
Serviço de monitoramento que:
- Coleta dados do sistema a cada 5 segundos
- Executa como foreground service
- Gera logs detalhados das atividades

### KeepAliveService
Serviço de proteção que:
- Verifica se outros serviços estão ativos
- Reinicia serviços automaticamente se necessário
- Mantém o aplicativo funcionando persistentemente

### BootReceiver
Receptor que inicia os serviços automaticamente após o boot do dispositivo.

## Permissões Necessárias

O aplicativo solicita as seguintes permissões:
- `DEVICE_POWER`: Controle de energia
- `WAKE_LOCK`: Manter dispositivo ativo
- `RECEIVE_BOOT_COMPLETED`: Iniciar após boot
- `FOREGROUND_SERVICE`: Executar serviços em primeiro plano
- `BIND_DEVICE_ADMIN`: Administrador de dispositivo
- `PACKAGE_USAGE_STATS`: Estatísticas de uso de aplicativos
- `SYSTEM_ALERT_WINDOW`: Exibir sobre outros apps

## Instalação

1. Compile o projeto usando Android Studio ou Gradle
2. Instale o APK no dispositivo
3. Ative o administrador de dispositivo quando solicitado
4. Conceda as permissões necessárias
5. Inicie o monitoramento

## Uso

1. **Ativar Administrador**: Pressione o botão para ativar o administrador de dispositivo
2. **Iniciar Monitoramento**: Use o botão para iniciar/parar o monitoramento
3. **Visualizar Logs**: Os logs aparecem na parte inferior da tela em tempo real

## Segurança e Ética

Este aplicativo foi desenvolvido para fins educacionais e de monitoramento legítimo. 

**IMPORTANTE**: 
- Use apenas em dispositivos próprios ou com autorização explícita
- Respeite a privacidade e leis locais
- O uso inadequado pode ser considerado malware

## Arquitetura

```
com.monitoramento.persistente/
├── MainActivity.kt                 # Interface principal
├── admin/
│   └── DeviceAdminReceiver.kt     # Administrador do dispositivo
├── services/
│   ├── MonitoringService.kt       # Serviço de monitoramento
│   └── KeepAliveService.kt        # Serviço de persistência
└── receivers/
    └── BootReceiver.kt            # Receptor de boot
```

## Requisitos

- Android API 21+ (Android 5.0)
- Kotlin 1.8+
- Android Gradle Plugin 8.0+

## Build

```bash
./gradlew assembleDebug
```

## Notas de Desenvolvimento

- O aplicativo usa foreground services para manter execução contínua
- Device Admin protege contra desinstalação acidental
- Keep-alive service garante que componentes sejam reiniciados se terminados
- Boot receiver garante funcionamento após reinicialização

## Limitações

- Algumas funcionalidades podem não funcionar em todos os dispositivos
- Otimizações de bateria do Android podem afetar a persistência
- Permissões de sistema podem ser limitadas em versões mais recentes do Android