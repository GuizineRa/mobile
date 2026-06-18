# 🚗 Controle de Manutenção de Veículos

Aplicativo mobile desenvolvido em **Flutter (Dart)** para gerenciamento de veículos e controle do histórico de manutenções realizadas.

O sistema permite cadastrar veículos, visualizar suas informações e registrar serviços de manutenção vinculados a cada veículo, mantendo os dados armazenados localmente através do banco de dados SQLite.

---

#  Sobre o Projeto

O projeto consiste em uma aplicação mobile para auxiliar no controle de manutenção de veículos.

O usuário pode:

- Cadastrar veículos.
- Consultar informações dos veículos cadastrados.
- Visualizar o histórico de manutenções.
- Registrar novos serviços realizados.
- Acompanhar quilometragem e custos de manutenção.

O aplicativo funciona de maneira **offline**, sem necessidade de conexão com internet.

---

#  Objetivo

Desenvolver uma aplicação mobile capaz de organizar informações relacionadas à manutenção de veículos, permitindo maior controle sobre serviços realizados e histórico do automóvel.

---

#  Funcionalidades

##  Cadastro de Veículo

Permite registrar um novo veículo contendo:

- Marca;
- Modelo;
- Ano;
- Placa;
- Quilometragem inicial.

---

##  Visualização do Registro

Ao selecionar um veículo, o aplicativo apresenta:

- Dados completos do veículo;
- Lista de manutenções realizadas;
- Histórico organizado dos serviços.

---

##  Registro de Nova Manutenção

Permite adicionar uma manutenção contendo:

- Tipo de serviço;
- Data;
- Quilometragem no momento da manutenção;
- Custo;
- Observações.

---

#  Arquitetura do Projeto

O aplicativo utiliza o padrão arquitetural **MVC (Model-View-Controller)**.

A separação das responsabilidades ocorre da seguinte forma:

```
             VIEW

              |
              |

          CONTROLLER

              |
              |

             MODEL

              |
              |

          DATABASE

              |
              |

            SQLite
```

---p

#  Estrutura de Pastas

```
lib/

├── main.dart
│
├── models/
│   ├── veiculo.dart
│   └── manutencao.dart
│
├── controllers/
│   ├── veiculo_controller.dart
│   └── manutencao_controller.dart
│
├── views/
│   ├── home_view.dart
│   ├── cadastro_veiculo_view.dart
│   ├── detalhes_veiculo_view.dart
│   └── cadastro_manutencao_view.dart
│
├── database/
│   └── database_helper.dart
│
└── routes/
    └── app_routes.dart
```

---

#  Descrição das Camadas

## Model

Responsável pela representação dos dados do sistema.

Contém:

- `veiculo.dart`
- `manutencao.dart`

Exemplo:

```
Veículo

id
marca
modelo
ano
placa
quilometragemInicial
```

```
Manutenção

id
veiculoId
tipoServico
data
quilometragem
custo
observacoes
```

---

## View

Responsável pela interface visual do aplicativo.

Telas:

### HomeView

Tela inicial contendo a lista de veículos cadastrados.

---

### CadastroVeiculoView

Tela para cadastro de veículos.

Campos:

- Marca;
- Modelo;
- Ano;
- Placa;
- Quilometragem inicial.

---

### DetalhesVeiculoView

Exibe:

- Informações do veículo;
- Histórico de manutenção.

---

### CadastroManutencaoView

Tela responsável pelo registro de novos serviços.

Campos:

- Serviço;
- Data;
- Quilometragem;
- Custo;
- Observações.

---

## Controller

Responsável pela lógica da aplicação.

Controladores:

```
VeiculoController

ManutencaoController
```

Responsabilidades:

- Receber dados das Views;
- Validar informações;
- Comunicar com o banco;
- Retornar resultados para a interface.

---

#  Banco de Dados

O aplicativo utiliza **SQLite** para armazenamento local.

O banco é criado automaticamente no dispositivo na primeira execução.

Arquivo responsável:

```
database/database_helper.dart
```

---

#  Estrutura do Banco

## Tabela: veiculos

| Campo | Tipo |
|-|-|
| id | INTEGER |
| marca | TEXT |
| modelo | TEXT |
| ano | INTEGER |
| placa | TEXT |
| quilometragemInicial | REAL |

---

## Tabela: manutencoes

| Campo | Tipo |
|-|-|
| id | INTEGER |
| veiculoId | INTEGER |
| tipoServico | TEXT |
| data | TEXT |
| quilometragem | REAL |
| custo | REAL |
| observacoes | TEXT |

---

#  Relacionamento

Um veículo pode possuir várias manutenções.

Representação:

```
Veículo

   1

   |

   |

   N

Manutenções
```

Exemplo:

```
Honda Civic

 ├── Troca de óleo
 ├── Revisão
 └── Troca de pneus
```

---

#  Tecnologias Utilizadas

| Tecnologia | Utilização |
|-|-|
| Flutter | Desenvolvimento Mobile |
| Dart | Linguagem de programação |
| SQLite | Banco de dados local |
| Sqflite | Comunicação Flutter com SQLite |
| MVC | Organização do código |

---

#  Dependências Principais

Arquivo:

```
pubspec.yaml
```

Dependências utilizadas:

```yaml
dependencies:

  flutter:
    sdk: flutter

  sqflite: ^2.3.0

  path: ^1.8.3

  intl: ^0.19.0
```

---

#  Como Executar o Projeto

## Pré-requisitos

Necessário possuir:

- Flutter SDK instalado;
- Android Studio ou VS Code;
- Emulador Android ou dispositivo físico.

---

## Instalação

Clone o projeto:

```bash
git clone <url-do-repositorio>
```

Entre na pasta:

```bash
cd controle_manutencao_veiculos
```

Instale as dependências:

```bash
flutter pub get
```

Execute:

```bash
flutter run
```

---

#  Compatibilidade

O aplicativo foi desenvolvido para:

- Android 8.0 ou superior;
- iOS 13 ou superior.

---

#  Características do Sistema

## Funcionamento Offline

Todas as informações são armazenadas localmente no dispositivo utilizando SQLite.

Não depende de:

- Servidores externos;
- Internet;
- APIs.

---

#  Requisitos Implementados

## Requisitos Funcionais

| Código | Descrição |
|-|-|
| RF-001 | Cadastro de veículos |
| RF-002 | Listagem de veículos |
| RF-003 | Visualização dos detalhes do veículo |
| RF-004 | Registro de manutenção |
| RF-005 | Histórico de manutenções |
| RF-006 | Persistência local utilizando SQLite |

---

## Requisitos Não Funcionais

| Código | Descrição |
|-|-|
| RNF-001 | Aplicação mobile Flutter |
| RNF-002 | Funcionamento offline |
| RNF-003 | Persistência local |
| RNF-004 | Arquitetura MVC |
| RNF-005 | Interface adaptável para dispositivos móveis |

---

#  Desenvolvimento

Projeto desenvolvido como atividade acadêmica para desenvolvimento de uma aplicação mobile utilizando Flutter.

---

#  Versão

```
Versão: 1.0
```
