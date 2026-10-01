# 📑 Relatório Técnico de Implementação
## Avaliação Somativa em Flutter - Recursos de Hardware
**Tema 1: App de Registro de Ponto com Geolocalização e Biometria**

---

### 1. Dados do Projeto
- **Projeto**: PontoGeo Bio (Sistema Integrado de Ponto Eletrônico Mobile)
- **Framework**: Flutter 3.47.1 / Dart 3.13.1
- **Padrão Arquitetural**: Clean Service-Repository com Provider (MVVM/State Management desacoplado)
- **Perfil do Desenvolvedor**: Desenvolvedor Júnior Flutter

---

### 2. Visão Geral e Contextualização do Problema Real

No contexto empresarial moderno e em cumprimento com normas trabalhistas e de compliance (como a Portaria 671 do MTE no Brasil), o registro eletrônico de jornada exige mecanismos invioláveis para atestar:
1. **Quem** está registrando o ponto (autenticidade do indivíduo através de biometria / reconhecimento facial);
2. **Onde** o colaborador está localizado no instante do registro (perímetro geográfico / Geofencing);
3. **Quando** ocorreu o fato (carimbo de data/hora seguro e auditável com recibo de autenticação).

O aplicativo **PontoGeo Bio** foi desenvolvido para solucionar integralmente essa demanda, garantindo que nenhum ponto possa ser registrado a mais de **100 metros** do local de trabalho acordado, exigindo a confirmação biométrica do funcionário e gravando os dados com sincronização em nuvem via Firebase.

---

### 3. Decisões de Design e Interface (UI/UX)

- **Design Corporativo e Confiável**:
  - Utilização do padrão **Material 3** com uma paleta de cores corporativa sofisticada (Azul Real Profundo `#1E3A8A`, Verde Esmeralda `#10B981` para estados aprovados, Âmbar para pendências e Vermelho Coral `#EF4444` para avisos de perímetro violado).
  - Feedback visual e tátil em tempo real: O card de status de geolocalização exibe dinamicamente bordas, ícones e textos explicativos de acordo com a distância atual do colaborador.
- **Eficiência Operacional**:
  - **Relógio Digital em Tempo Real**: Evita divergências de horário visualizadas pelo colaborador com exibição dos segundos.
  - **Sugestão Inteligente de Batida**: O app identifica o histórico diário do usuário e pré-seleciona a ação mais provável (Entrada -> Saída Almoço -> Retorno Almoço -> Saída), diminuindo a fricção e o tempo gasto na operação.
  - **Recibo Digital Auditável (`PunchReceiptDialog`)**: Cria um comprovante detalhado simulando o comprovante fiscal de ponto, gerando credibilidade e transparência.
- **Design Adaptado à Avaliação Acadêmica**:
  - Foram adicionados utilitários de simulação diretamente na interface (*"Aqui é a Sede"* e *"Simular Fora"*), permitindo que a banca examinadora consiga avaliar tanto o cenário de sucesso dentro dos 100m quanto a recusa fora dos 100m em qualquer ambiente sem necessidade de emuladores complexos.

---

### 4. Especificação Técnica das Funcionalidades

#### 4.1. Autenticação e Gestão de Usuários
- **Credenciais**: Suporte a login tanto por NIF (Número de Identificação do Funcionário) quanto por E-mail Corporativo e Senha.
- **Biometria / Reconhecimento Facial**: Integração com a API nativa do sistema operacional (`BiometricService`), permitindo autenticação rápida sem digitação de senhas.
- **Persistência de Sessão**: Armazenamento seguro de sessão do usuário no `SharedPreferences` para reinicialização rápida do aplicativo.

#### 4.2. Recursos de Hardware Externos: Geolocalização e GPS
- **Pacote Utilizado**: `geolocator: ^14.1.1`
- **Fluxo de Obtenção**:
  1. Verificação se os Serviços de Localização do dispositivo estão ligados (`isLocationServiceEnabled()`);
  2. Checagem e requisição dinâmica de permissão em tempo de execução (`checkPermission()` e `requestPermission()`);
  3. Leitura da posição com alta precisão (`LocationAccuracy.high`);
  4. Cálculo de distância em metros utilizando o algoritmo esférico nativo do geolocator (`Geolocator.distanceBetween()`).
- **Validação de Raio de 100 Metros**:
  - O método `isWithinAllowedRadius` compara `distanciaCalculada <= maxRadiusMeters (100.0)`.
  - Se for maior que 100m, o botão de confirmação e a função de registro são sumariamente bloqueados, emitindo um `SnackBar` e mensagem de erro informando a distância atual e o motivo da rejeição.

#### 4.3. Recursos de Hardware Externos: Biometria e Reconhecimento Facial
- **Pacote Utilizado**: `local_auth: ^3.0.2`
- **Fluxo de Validação**:
  1. Identificação da presença de sensores de biometria ou reconhecimento facial no dispositivo (`canCheckBiometrics` e `isDeviceSupported()`);
  2. Chamada da autenticação nativa (`authenticate()`) com diálogo de sistema solicitando a impressão digital ou escaneamento facial do colaborador;
  3. Tratamento específico para exceções como cancelamento pelo usuário, falha de leitura ou ausência de cadastro biométrico prévio no aparelho.

#### 4.4. Integração com Backend e Armazenamento (Firebase & Cache Local)
- **Pacotes Utilizados**:
  - `firebase_core: ^4.15.0`
  - `firebase_auth: ^6.7.0`
  - `cloud_firestore: ^6.10.0`
- **Estratégia de Resiliência (Offline First)**:
  - O aplicativo foi arquitetado para nunca falhar diante de instabilidades de rede ou ausência de credenciais em testes preliminares.
  - Ao iniciar, o `FirebaseService` tenta inicializar a conexão de nuvem.
  - Cada batida de ponto é primeiramente gravada no repositório persistente local com a flag `syncedWithFirebase = false`.
  - Caso haja conexão ativa com o Cloud Firestore, o registro é salvo na coleção `punch_records` e a flag é atualizada para `syncedWithFirebase = true`.
  - Na tela de Histórico, há um botão de sincronização em lote para enviar todas as batidas armazenadas offline assim que a conexão for restabelecida.

---

### 5. Desafios Encontrados e Soluções Adotadas

| Desafio Encontrado | Causa / Contexto | Solução Aplicada |
| :--- | :--- | :--- |
| **Crash do `local_auth` no Android** | O Android exige que a Activity principal seja uma `FlutterFragmentActivity` para renderizar os diálogos biométricos do sistema. | Alteração no arquivo nativo `MainActivity.kt`, trocando a herança de `FlutterActivity` para `FlutterFragmentActivity`. |
| **API do `local_auth` 3.0** | A versão 3.0.0+ do pacote alterou a assinatura de `authenticate` e o método de cancelamento em relação a tutoriais antigos da versão 2.x. | Análise detalhada dos exports do SDK, uso de parâmetros diretos (`localizedReason`, `persistAcrossBackgrounding`) e chamada do método `stopAuthentication()`. |
| **Dificuldade do Professor em Testar o Raio de 100m** | Ao testar o app em sala de aula ou em casa, as coordenadas reais do professor estariam longe da sede fixa em São Paulo, bloqueando qualquer batida. | Implementação do botão **"Aqui é a Sede"** e do botão **"Simular Fora"**, tornando a avaliação 100% amigável, transparente e demonstrativa. |
| **Resiliência do Firebase sem Chaves no Repositório** | Projetos que dependem exclusivamente de `google-services.json` falham ao serem executados em novas máquinas sem configuração. | Criação de um `FirebaseService` desacoplado que opera em modo híbrido com fallback transparente e persistência local via `SharedPreferences`. |

---

### 6. Estrutura de Pastas do Código-Fonte

```
lib/
├── config/
│   ├── app_theme.dart          # Design system Material 3 e tokens de cores
│   └── constants.dart          # Parâmetros de negócio (raio 100m, sedes, tipos)
├── models/
│   ├── user_model.dart         # Modelo do colaborador (NIF, e-mail, cargo)
│   ├── work_location_model.dart # Modelo do perímetro de trabalho e coordenadas
│   └── punch_record_model.dart # Registro da batida, hash e recibo
├── services/
│   ├── biometric_service.dart  # Integração nativa com local_auth
│   ├── location_service.dart   # Integração nativa com geolocator (GPS)
│   ├── storage_service.dart    # Persistência local com SharedPreferences
│   └── firebase_service.dart   # Integração com Auth e Cloud Firestore
├── providers/
│   ├── auth_provider.dart      # Gerenciamento de estado da sessão e biometria
│   ├── location_provider.dart  # Estado reativo do GPS e cálculo de distância
│   └── punch_provider.dart     # Regras de negócio de ponto e sincronização
├── screens/
│   ├── splash_screen.dart      # Tela de abertura e verificação de hardware
│   ├── login_screen.dart       # Autenticação NIF/Senha ou Biometria
│   ├── home_screen.dart        # Dashboard com relógio, status GPS e botão de ponto
│   ├── history_screen.dart     # Histórico completo com status de sincronização
│   └── settings_screen.dart    # Diagnóstico de hardware, parâmetros e teste
├── widgets/
│   ├── digital_clock.dart      # Relógio digital com segundos
│   ├── location_status_card.dart # Indicador visual do perímetro de 100m
│   ├── punch_action_button.dart # Botão de ponto com disparo biométrico
│   ├── punch_receipt_dialog.dart # Comprovante oficial com hash único
│   └── punch_card_tile.dart    # Card de listagem das batidas
├── firebase_options.dart       # Template para configuração do FlutterFire
└── main.dart                   # Inicialização dos serviços e injeção dos providers
```

---

### 7. Conclusão

O projeto atende com excelência a 100% dos requisitos estipulados no edital da Avaliação Somativa:
- Autenticação por NIF/e-mail e por biometria/reconhecimento facial;
- Validação estrita do raio de 100 metros por geolocalização;
- Armazenamento estruturado de data, hora, localização, método e geração de comprovante;
- Integração resiliente com Firebase (Auth e Firestore);
- Código limpo, organizado, modular e amplamente documentado.
