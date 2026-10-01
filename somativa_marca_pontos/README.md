# 🕒 PontoGeo Bio - Aplicativo de Registro de Ponto com Geolocalização e Biometria

> **Avaliação Somativa em Flutter - Recursos de Hardware (Tema 1)**  
> Aplicação mobile corporativa desenvolvida sob medida para controle seguro de jornada de trabalho utilizando validação de perímetro geográfico (Geofencing até 100m) e autenticação biométrica / reconhecimento facial com sincronização em nuvem via Firebase.

---

## 📋 Sumário
1. [Sobre o Projeto](#-sobre-o-projeto)
2. [Funcionalidades Principais](#-funcionalidades-principais)
3. [Tecnologias e Dependências](#-tecnologias-e-dependências)
4. [Recursos de Hardware Utilizados](#-recursos-de-hardware-utilizados)
5. [Credenciais de Demonstração (Para Correção)](#-credenciais-de-demonstração-para-correção)
6. [Passo a Passo para Executar Localmente](#-passo-a-passo-para-executar-localmente)
7. [Configuração do Firebase (Opcional)](#-configuração-do-firebase-opcional)
8. [Configuração de Permissões Nativa (Android)](#-configuração-de-permissões-nativa-android)
9. [Ferramentas de Teste Integradas](#-ferramentas-de-teste-integradas)

---

## 🚀 Sobre o Projeto

O **PontoGeo Bio** é um aplicativo mobile nativo desenvolvido em Flutter/Dart projetado para solucionar problemas reais de compliance trabalhista e registro de ponto eletrônico corporativo. 

Para impedir fraudes e garantir autenticidade da batida:
- O colaborador **somente consegue registrar o ponto se estiver em um raio de até 100 metros** do perímetro cadastrado da empresa.
- A validação da identidade é realizada por **reconhecimento facial / biometria nativa** do aparelho (ou credenciais NIF/Senha).
- Cada registro gera um **Comprovante Digital com Hash Único**, coordenadas de GPS, distância da sede e data/hora com precisão de segundos.
- O sistema opera tanto **integrado ao Firebase (Auth e Firestore)** quanto em **modo local resiliente**, permitindo avaliação imediata mesmo sem conexão prévia com o console do Firebase.

---

## ✨ Funcionalidades Principais

- 🔐 **Autenticação Dupla**:
  - Login via NIF / E-mail corporativo e senha;
  - Login biométrico por impressão digital ou reconhecimento facial.
- 📍 **Geolocalização e Geofencing**:
  - Leitura do GPS em tempo real;
  - Cálculo de distância via fórmula esférica de Haversine (`geolocator`);
  - Bloqueio automático de batida fora do raio permitido (> 100m) com feedback visual imediato.
- ⏱️ **Registro de Ponto Inteligente**:
  - Entrada, Saída para Almoço, Retorno do Almoço e Saída;
  - Sugestão automática do próximo tipo de batida conforme o fluxo do dia;
  - Horário de Brasília com relógio digital em tempo real.
- 📄 **Comprovante Digital de Ponto**:
  - Exibição de recibo auditável com código identificador único (REC-XXXX), coordenadas, método de autenticação e carimbo de data/hora.
- ☁️ **Integração Híbrida com Firebase**:
  - Persistência e sincronização de batidas no Cloud Firestore e autenticação no Firebase Auth;
  - Modo offline e cache local (`SharedPreferences`) para que nenhuma batida se perca.
- 🛠️ **Painel de Avaliação & Simulação**:
  - Botão *"Aqui é a Sede"* (redefine a sede para onde o avaliador estiver, permitindo testar com sucesso em qualquer local);
  - Botão *"Simular Fora"* (simula distância > 100m para testar a recusa do ponto).

---

## 🛠️ Tecnologias e Dependências

- **Flutter SDK**: 3.47.1+ / **Dart SDK**: 3.13.1+
- **Gerenciamento de Estado**: `provider: ^6.1.5`
- **Recursos de Hardware**:
  - Biometria: `local_auth: ^3.0.2`
  - Geolocalização / GPS: `geolocator: ^14.1.1`
- **Backend & Nuvem**:
  - `firebase_core: ^4.15.0`
  - `firebase_auth: ^6.7.0`
  - `cloud_firestore: ^6.10.0`
- **Utilitários e Persistência**:
  - `shared_preferences: ^2.5.5`
  - `intl: ^0.20.3` (Internacionalização pt_BR)
  - `uuid: ^4.6.0`

---

## 📱 Recursos de Hardware Utilizados

| Recurso de Hardware | Pacote | Finalidade |
| :--- | :--- | :--- |
| **Sensor Biométrico / Câmera Facial** | `local_auth` | Autenticação do colaborador no login e confirmação no momento exato do registro de ponto |
| **GPS / Módulo de Geolocalização** | `geolocator` | Obtenção das coordenadas atuais (latitude/longitude) e validação da distância `<= 100 metros` da sede |

---

## 👤 Credenciais de Demonstração (Para Correção)

Na tela de login há botões de **preenchimento rápido** com 1 toque:

- **Usuário 1 (Desenvolvedor Jr)**:
  - **NIF**: `102030` | **E-mail**: `joao.silva@empresa.com.br`
  - **Senha**: `123456`
- **Usuário 2 (Analista)**:
  - **NIF**: `405060` | **E-mail**: `maria.souza@empresa.com.br`
  - **Senha**: `123456`

*(Qualquer outro NIF com senha de pelo menos 4 dígitos também pode ser utilizado para testes livres).*

---

## 💻 Passo a Passo para Executar Localmente

### 1. Pré-requisitos
- Flutter SDK instalado e configurado no PATH (`flutter doctor`).
- Android Studio ou VS Code com emulador Android ou celular conectado via Depuração USB.

### 2. Clonar / Acessar a pasta do projeto
```bash
cd c:\Users\35T1\Documents\DSGui\mobile\somativa_marca_pontos
```

### 3. Baixar os pacotes
```bash
flutter pub get
```

### 4. Executar no emulador ou dispositivo físico
```bash
flutter run
```

> **Dica para emuladores**: No emulador Android, configure a localização simulada nas reticências laterais (`...` -> Location) ou utilize o botão embutido no app **"Aqui é a Sede"**.

---

## ☁️ Configuração do Firebase (Opcional)

O aplicativo já inclui uma camada de resiliência e opera perfeitamente com armazenamento persistente em modo local/fallback. Caso queira conectar ao seu próprio console Firebase:

1. Instale a CLI do Firebase e do FlutterFire:
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   ```
2. No diretório do projeto, execute:
   ```bash
   flutterfire configure
   ```
3. Selecione o projeto criado no console do Firebase (com Firebase Auth e Firestore ativados). O app sincronizará automaticamente todas as batidas com a nuvem.

---

## ⚙️ Configuração de Permissões Nativa (Android)

As permissões já foram devidamente declaradas e configuradas nos arquivos nativos do projeto:

- `android/app/src/main/AndroidManifest.xml`:
  - `ACCESS_FINE_LOCATION`: Precisão de GPS por satélite.
  - `ACCESS_COARSE_LOCATION`: Localização aproximada por rede/Wi-Fi.
  - `USE_BIOMETRIC` & `USE_FINGERPRINT`: Acesso a leitores biométricos e reconhecimento facial.
  - `INTERNET`: Comunicação com serviços web e Firebase.
- `android/app/src/main/kotlin/.../MainActivity.kt`:
  - Extensão da classe alterada para `FlutterFragmentActivity` conforme exigido pelo `local_auth`.

---

## 🧪 Ferramentas de Teste Integradas

Pensando em facilitar a avaliação do professor, a aplicação possui utilitários na interface:
1. **Modo "Aqui é a Sede"**: Localizado no card de localização e na aba *Ajustes & GPS*. Define a coordenada atual do aparelho como a sede da empresa (raio de 100m passa a valer para onde o avaliador estiver).
2. **Modo "Simular Fora"**: Afasta propositalmente a localização em ~350 metros para permitir verificar se o bloqueio e a mensagem de erro do aplicativo funcionam corretamente.
3. **Alternância de Colaboradores**: Troque facilmente entre os colaboradores na aba de Ajustes sem precisar deslogar.
4. **Comprovante em PDF / Modal**: Toque em qualquer registro no histórico para visualizar o comprovante auditável com Hash de segurança.
