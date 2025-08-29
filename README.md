# 🚌 GoCampus

[![Flutter](https://img.shields.io/badge/Flutter-3.5.3+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.5.3+-blue.svg)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Authentication-orange.svg)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> **Plataforma de Conectividade para Transporte Universitário**

O GoCampus é uma solução inovadora que conecta estudantes universitários a empresas de transporte, facilitando a busca, avaliação e escolha dos melhores serviços de transporte para suas necessidades acadêmicas.

## 📋 Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Funcionalidades](#funcionalidades)
- [Tecnologias](#tecnologias)
- [Arquitetura](#arquitetura)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Configuração](#configuração)
- [Uso](#uso)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Contribuição](#contribuição)
- [Licença](#licença)

## 🎯 Sobre o Projeto

O GoCampus resolve um problema real enfrentado por estudantes universitários: encontrar transporte confiável e adequado para suas rotinas acadêmicas. A plataforma oferece uma interface intuitiva onde usuários podem:

- **Buscar empresas** de transporte que atendem suas universidades
- **Avaliar serviços** baseado em experiências reais
- **Filtrar opções** por região, universidade e rotas disponíveis
- **Comparar empresas** através de avaliações e comentários

Para empresas de transporte, o GoCampus representa uma oportunidade de:
- **Aumentar visibilidade** no mercado universitário
- **Gerenciar rotas** de forma eficiente
- **Receber feedback** direto dos usuários
- **Expandir clientela** através de uma plataforma digital

## ✨ Funcionalidades

### 👤 Para Usuários
- **🔍 Busca Inteligente**: Encontre empresas por universidade, região ou rota específica
- **⭐ Sistema de Avaliações**: Avalie empresas com notas de 1-5 estrelas e comentários
- **📍 Filtros Avançados**: Filtre por localização, universidade e tipo de serviço
- **🗺️ Visualização de Rotas**: Veja todas as rotas disponíveis de cada empresa
- **📱 Interface Responsiva**: Acesse de qualquer dispositivo com design adaptativo

### 🏢 Para Empresas
- **📝 Cadastro Completo**: Registre sua empresa com informações detalhadas
- **🛣️ Gerenciamento de Rotas**: Adicione, edite e remova rotas conforme necessário
- **📊 Dashboard de Performance**: Acompanhe avaliações e feedback dos usuários
- **📈 Visibilidade Digital**: Aumente sua presença no mercado universitário

## 🛠️ Tecnologias

### Frontend
- **Flutter 3.5.3+** - Framework cross-platform para desenvolvimento mobile
- **Dart 3.5.3+** - Linguagem de programação moderna e type-safe
- **Material Design 3** - Design system do Google para interfaces consistentes

### Backend & Infraestrutura
- **Java** - Linguagem principal do servidor backend
- **Kotlin** - Implementação nativa Android com MethodChannel
- **Socket TCP** - Comunicação cliente-servidor via rede
- **MongoDB** - Banco de dados NoSQL para flexibilidade de dados

### Autenticação & Serviços
- **Firebase Authentication** - Sistema de autenticação seguro
- **Firebase Core** - Configuração e inicialização dos serviços Firebase
- **MethodChannel** - Ponte de comunicação Flutter-Nativo

### Dependências Principais
```yaml
dependencies:
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  http: ^1.2.2
  shared_preferences: ^2.0.15
  flutter_rating_bar: ^4.0.1
  intl: ^0.19.0
```

## 🏗️ Arquitetura

O projeto segue uma arquitetura híbrida que combina:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │    │   MethodChannel │    │   Java Server   │
│   (Frontend)    │◄──►│   (Bridge)      │◄──►│   (Backend)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Firebase Auth  │    │   Socket TCP    │    │     MongoDB     │
│  (Auth Service) │    │   (Network)     │    │   (Database)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Componentes Principais
- **Flutter UI**: Interface do usuário com Material Design
- **MethodChannel**: Comunicação entre Flutter e código nativo
- **Kotlin Bridge**: Implementação Android com conexão TCP
- **Java Server**: Backend com operações CRUD
- **MongoDB**: Armazenamento persistente de dados

## 📋 Pré-requisitos

### Desenvolvimento
- **Flutter SDK** 3.5.3 ou superior
- **Dart SDK** 3.5.3 ou superior
- **Android Studio** ou **VS Code** com extensões Flutter
- **Git** para controle de versão

### Sistema
- **macOS** 10.15+ / **Windows** 10+ / **Linux** Ubuntu 18.04+
- **Java JDK** 8 ou superior
- **MongoDB** 4.4+ instalado e rodando
- **Node.js** 14+ (para Firebase CLI)

### Mobile
- **Android** 5.0+ (API 21+)
- **iOS** 12.0+ (se desenvolvendo para iOS)

## 🚀 Instalação

### 1. Clone o Repositório
```bash
git clone https://github.com/seu-usuario/goCampus.git
cd goCampus
```

### 2. Instale as Dependências Flutter
```bash
flutter pub get
```

### 3. Configure o Firebase
```bash
# Instale o Firebase CLI
npm install -g firebase-tools

# Faça login no Firebase
firebase login

# Configure o projeto
firebase init
```

### 4. Configure o Backend Java
```bash
# Certifique-se de que o servidor Java está rodando na porta 3000
# O arquivo SERVIDORMAVEN-1.0-SNAPSHOT.jar deve estar em android/app/libs/
```

## ⚙️ Configuração

### Firebase Configuration
1. Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
2. Adicione aplicações Android e iOS
3. Baixe os arquivos de configuração:
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → `ios/Runner/`

### Configuração do Servidor
```kotlin
// android/app/src/main/kotlin/com/example/go_campus/MainActivity.kt
val host = "10.0.2.2"  // Para emulador Android
val porta = 3000        // Porta do servidor Java
```

### Variáveis de Ambiente
```bash
# Crie um arquivo .env na raiz do projeto
FIREBASE_PROJECT_ID=seu-projeto-id
MONGODB_URI=sua-uri-mongodb
SERVER_HOST=seu-host-servidor
SERVER_PORT=3000
```

## 🎮 Uso

### Executando o Projeto

#### Desenvolvimento
```bash
# Modo debug
flutter run

# Modo release
flutter run --release

# Para plataforma específica
flutter run -d android
flutter run -d ios
```

#### Build para Produção
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

### Funcionalidades Principais

#### 1. **Splash Screen**
- Tela de inicialização com logo do GoCampus
- Redirecionamento automático baseado no estado de autenticação

#### 2. **Autenticação**
- Login com email/senha via Firebase
- Registro de usuários (pessoa física/empresa)
- Recuperação de senha

#### 3. **Busca e Filtros**
- Busca por empresa, região ou universidade
- Filtros avançados por tipo de serviço
- Resultados ordenados por relevância

#### 4. **Avaliações**
- Sistema de rating com 5 estrelas
- Comentários e feedback detalhado
- Histórico de avaliações por usuário

## 📁 Estrutura do Projeto

```
goCampus/
├── 📱 lib/                          # Código principal Flutter
│   ├── 📄 main.dart                # Ponto de entrada da aplicação
│   ├── 🎨 splash_screen.dart       # Tela de inicialização
│   ├── 🔐 login_screen.dart        # Tela de login
│   ├── 📝 register_screen.dart     # Tela de registro
│   ├── 🔍 search_screen.dart       # Tela de busca
│   ├── 🏢 company_screen.dart      # Lista de empresas
│   ├── 📋 company_details_screen.dart # Detalhes da empresa
│   ├── ⭐ company_evaluation_screen.dart # Avaliações
│   ├── ⚙️ firebase_options.dart    # Configuração Firebase
│   └── 🔧 services/                # Serviços da aplicação
│       ├── 🔐 auth_service.dart    # Autenticação
│       ├── 📝 register_service.dart # Registro
│       └── 📅 date_picker_service.dart # Seleção de datas
├── 🤖 android/                     # Configurações Android
│   └── app/
│       ├── 📱 src/main/kotlin/     # Código nativo Kotlin
│       ├── 📦 libs/                # Bibliotecas JAR
│       └── ⚙️ build.gradle         # Configuração de build
├── 🍎 ios/                         # Configurações iOS
├── 🐧 linux/                       # Configurações Linux
├── 🪟 windows/                     # Configurações Windows
├── 🌐 web/                         # Configurações Web
├── 📦 assets/                      # Recursos estáticos
├── 🧪 test/                        # Testes automatizados
├── 📋 pubspec.yaml                 # Dependências Flutter
├── 🔥 firebase.json                # Configuração Firebase
└── 📖 README.md                    # Este arquivo
```

### Arquivos de Configuração Importantes
- **`pubspec.yaml`**: Dependências e configurações Flutter
- **`firebase.json`**: Configuração do Firebase
- **`android/app/build.gradle`**: Configuração de build Android
- **`android/app/src/main/kotlin/.../MainActivity.kt`**: Bridge nativo Android

## 🤝 Contribuição

Contribuições são sempre bem-vindas! Para contribuir:

### 1. Fork o Projeto
```bash
git fork https://github.com/seu-usuario/goCampus.git
```

### 2. Crie uma Branch
```bash
git checkout -b feature/NovaFuncionalidade
```

### 3. Commit suas Mudanças
```bash
git commit -m 'Adiciona nova funcionalidade'
```

### 4. Push para a Branch
```bash
git push origin feature/NovaFuncionalidade
```

### 5. Abra um Pull Request

### Diretrizes de Contribuição
- Siga o padrão de código Dart/Flutter
- Adicione testes para novas funcionalidades
- Mantenha a documentação atualizada
- Use commits semânticos (feat:, fix:, docs:, etc.)

## 📝 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 📞 Suporte

- **Issues**: [GitHub Issues](https://github.com/seu-usuario/goCampus/issues)
- **Discord**: [Servidor da Comunidade](https://discord.gg/gocampus)
- **Email**: suporte@gocampus.com

## 🙏 Agradecimentos

- **Flutter Team** pelo framework incrível
- **Firebase** pelos serviços de backend
- **Comunidade Flutter** pelo suporte contínuo
- **Contribuidores** que ajudaram a tornar este projeto realidade

---

<div align="center">

**Desenvolvido com ❤️ pela equipe GoCampus**

[![Flutter](https://img.shields.io/badge/Made%20with-Flutter-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Powered%20by-Firebase-orange.svg)](https://firebase.google.com/)

</div>