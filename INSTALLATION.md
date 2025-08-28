# Instruções de Instalação e Teste

## Compilação do Projeto

### Pré-requisitos
- Android Studio Arctic Fox (2020.3.1) ou superior
- Android SDK API 21+ (Android 5.0)
- Java 8 ou superior
- Kotlin 1.8+

### Passos para Compilação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/wiversonlima/AlocacaoEstatica.git
   cd AlocacaoEstatica
   ```

2. **Abra no Android Studio**
   - Abra o Android Studio
   - File > Open > Selecione a pasta do projeto
   - Aguarde a sincronização do Gradle

3. **Compile o projeto**
   ```bash
   ./gradlew assembleDebug
   ```

4. **Instale no dispositivo**
   ```bash
   ./gradlew installDebug
   ```

## Configuração no Dispositivo

### 1. Permissões Iniciais
Após instalar, o aplicativo solicitará várias permissões:
- Ative "Fontes desconhecidas" se necessário
- Permita instalação do APK

### 2. Ativação do Administrador de Dispositivo
1. Abra o aplicativo "Monitoramento Persistente"
2. Toque em "Ativar Administrador"
3. Na tela do sistema, toque em "Ativar este administrador de dispositivo"
4. O status mudará para "Ativado" (verde)

### 3. Configuração de Permissões Especiais
O aplicativo pode solicitar permissões adicionais:
- **Estatísticas de uso**: Settings > Apps > Special access > Usage data access
- **Overlay**: Settings > Apps > Special access > Display over other apps
- **Otimização de bateria**: Settings > Apps > Special access > Optimize battery usage (desative para este app)

### 4. Iniciar Monitoramento
1. Volte ao aplicativo
2. Toque em "Iniciar Monitoramento"
3. O status mudará para "Ativado" (verde)
4. Logs aparecerão na parte inferior da tela

## Funcionalidades de Teste

### 1. Teste de Persistência
- **Reinicialização**: Reinicie o dispositivo e verifique se o aplicativo inicia automaticamente
- **Kill de processo**: Use um task killer para terminar o processo e observe a reinicialização automática
- **Tentativa de desinstalação**: Tente desinstalar o aplicativo (deve ser bloqueado se admin ativo)

### 2. Teste de Monitoramento
- **Logs em tempo real**: Verifique se logs aparecem a cada 5 segundos
- **Dados do sistema**: Confirme se CPU, memória e bateria são coletados
- **Notificação persistente**: Verifique se a notificação permanece na barra de status

### 3. Teste de Serviços
- **MonitoringService**: Deve aparecer na lista de serviços em execução
- **KeepAliveService**: Deve reiniciar outros serviços se terminados
- **Notificações**: Duas notificações devem estar ativas (Monitoramento e Keep Alive)

## Verificação de Funcionamento

### Logs Esperados
```
[HH:mm:ss] CPU: XX% | MEM: XXXMB | BAT: XX%
```

### Sinais de Funcionamento Correto
- ✅ Status "Ativado" para Administrador
- ✅ Status "Ativado" para Monitoramento  
- ✅ Logs aparecendo a cada 5 segundos
- ✅ Notificações persistentes na barra de status
- ✅ Aplicativo reinicia após boot
- ✅ Serviços reiniciam se terminados

### Resolução de Problemas

#### Administrador não ativa
- Verifique se é um dispositivo com permissões de administrador
- Alguns dispositivos corporativos podem bloquear esta funcionalidade

#### Monitoramento não funciona
- Verifique permissões de overlay e estatísticas de uso
- Desative otimização de bateria para o aplicativo
- Verifique se o dispositivo permite foreground services

#### Aplicativo não persiste
- Confirme que o administrador de dispositivo está ativo
- Verifique se o dispositivo não tem políticas que impedem persistência
- Alguns launchers customizados podem interferir

#### Logs não aparecem
- Verifique se o serviço de monitoramento está em execução
- Confirme que as permissões necessárias foram concedidas
- Reinicie o aplicativo

## Desinstalação

Para remover completamente o aplicativo:

1. **Desative o administrador primeiro**
   - Abra o aplicativo
   - Toque em "Desativar Administrador"
   - Confirme a desativação

2. **Desinstale normalmente**
   - Settings > Apps > Monitoramento Persistente > Uninstall
   - Ou arraste o ícone para a lixeira

**Importante**: Sem desativar o administrador primeiro, a desinstalação será bloqueada.

## Considerações de Segurança

- Use apenas em dispositivos próprios ou com autorização
- O aplicativo tem capacidades avançadas que podem ser consideradas intrusivas
- Respeite leis locais sobre monitoramento e privacidade
- Em ambientes corporativos, obtenha aprovação da TI antes de instalar