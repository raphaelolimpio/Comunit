# Comunit - Documentação do Projeto

## Visão Geral

**Comunit** (anteriormente chamado de "dicionario") é uma aplicação Flutter multiplataforma que funciona como uma comunidade interativa. O projeto oferece recursos de chat em tempo real, chamadas de vídeo (LiveKit), gestão de favoritos, busca de termos/tópicos e autenticação com Google Sign-In.

A aplicação é construída com Dart/Flutter, suportando iOS, Android, Web, Windows, macOS e Linux, utilizando uma arquitetura em camadas com separação clara entre UI, serviços de negócio e configuração.

---

## Composição Técnica

### Stack Tecnológico

- **Linguagem Primária:** Dart (74.7%)
- **Suporte Nativo:** C++ (12.7%), CMake (9.8%), Swift (1.4%), C (0.7%)
- **Runtime/Framework:** Flutter (SDK ^3.9.2)
- **Banco de Dados Local:** SQLite (via `sqflite`)
- **Gerenciamento de Estado:** Provider (v6.1.5+1)
- **Comunicação:** HTTP (v1.5.0), WebSocket (v3.0.3)
- **Multimídia:** LiveKit Client (v2.2.0) para chamadas de vídeo
- **Autenticação:** Google Sign-In (v7.2.0)
- **UI Adicional:** Flutter TypeAhead (busca com autocompletar), Convex Bottom Bar (navegação customizada)

### Dependências Principais

```yaml
flutter: SDK v3.9.2
provider: ^6.1.5+1              # State management
sqflite: ^2.4.2                 # SQLite database
http: ^1.5.0                    # HTTP requests
livekit_client: ^2.2.0          # Video/audio calls
google_sign_in: ^7.2.0          # Google authentication
web_socket_channel: ^3.0.3      # WebSocket communication
flutter_typeahead: ^5.2.0       # Search with suggestions
convex_bottom_bar: ^3.2.0       # Custom bottom navigation
shared_preferences: ^2.5.3      # Local preferences
flutter_highlight: ^0.7.0       # Code syntax highlighting
```

---

## Arquitetura e Organização

```
lib/
├── main.dart                    # Entry point, Theme setup com Provider
├── Config/                      # Configurações centralizadas
│   ├── Api/                     # Endpoints e cliente HTTP
│   ├── db/                      # Inicialização do SQLite
│   ├── cache/                   # Cache local (SharedPreferences)
│   ├── server/                  # Configurações de servidor
│   └── model/                   # Modelos de dados
├── Service/                     # Camada de negócio
│   ├── auth_service.dart        # Autenticação (Google Sign-In)
│   ├── chat_service.dart        # Mensagens em tempo real
│   ├── call_service.dart        # Gerenciamento de chamadas (LiveKit)
│   ├── termo_service.dart       # CRUD de termos/palavras
│   ├── topico_service.dart      # Gerenciamento de tópicos
│   ├── favorite_service.dart    # Gestão de favoritos
│   ├── Creat_service.dart       # Criação de recursos
│   └── Validation_service.dart  # Validação de dados
├── view/                        # Camada de apresentação (Widgets)
│   ├── Home_widget.dart         # Tela inicial
│   ├── Add_widget.dart          # Adicionar novo termo/tópico
│   ├── Detail_widget.dart       # Detalhe de um termo
│   ├── Favorite_widget.dart     # Lista de favoritos
│   └── Termo_widget.dart        # Tela de termos/dicionário
├── DS/                          # Design System e Componentes
│   ├── Components/              # Componentes reutilizáveis
│   │   ├── Button/              # Botões customizados
│   │   ├── Card/                # Cards reutilizáveis
│   │   ├── Text/                # Componentes de texto estilizado
│   │   ├── IconText/            # Ícone + texto
│   │   ├── IconTextForm/        # Campo de formulário com ícone
│   │   ├── Icons/               # Ícones customizados
│   │   ├── appBar/              # App bars customizadas
│   │   ├── appBarSearch/        # App bar com busca
│   │   ├── searchView/          # Widget de busca
│   │   ├── codeBlockForm/       # Bloco de código para exibição
│   │   ├── bash/                # Componentes para terminal/bash
│   │   ├── Reactive/            # Componentes reativos
│   │   └── theme/               # Gerenciamento de temas (claro/escuro)
│   ├── Layout/                  # Layouts reutilizáveis
│   └── page/                    # Páginas completas
├── shared/                      # Utilities compartilhadas
│   ├── color.dart               # Paleta de cores (light e dark mode)
│   └── style.dart               # Estilos globais de texto
├── Splash_Screen/               # Tela de carregamento inicial
│   └── Splash_Screen.dart       # Widget com animação splash
└── android/, ios/, web/, windows/, macos/, linux/
                                # Pastas nativas de cada plataforma
```

### Fluxo de Dados

1. **Inicialização:** `main.dart` carrega `.env`, inicializa `MultiProvider` com `ThemeService`
2. **Navegação:** `Splash_Screen` → `Home_widget` → Outras telas via navegação inferior
3. **Estado:** Provider gerencia tema (light/dark) globalmente
4. **Serviços:** Cada widget chama serviços (`auth_service`, `chat_service`, etc.) para dados
5. **Cache Local:** SQLite para persistência, SharedPreferences para preferências
6. **API:** HTTP requests via Config/Api para backend

---

## Funcionalidades Principais

### 1. **Autenticação & Perfil**
- Google Sign-In integrado
- Login seguro sem persistência de senha
- Gerenciamento de usuário

### 2. **Chat em Tempo Real**
- WebSocket para mensagens instantâneas (`web_socket_channel`)
- Chat service que sincroniza mensagens

### 3. **Chamadas de Vídeo**
- Integração com LiveKit para video/áudio
- Call service para iniciar e gerenciar sessões

### 4. **Dicionário/Termos**
- Busca de termos/palavras com TypeAhead
- Detalhe completo com metadados
- CRUD via termo_service

### 5. **Tópicos & Comunidade**
- Organização por tópicos
- Topico_service para gerenciar tópicos

### 6. **Favoritos**
- Marcar termos/tópicos como favoritos
- Tela dedicada com lista de favoritos
- Persistência local

### 7. **Tema & Design**
- Light Mode: Cores claras, tom profissional
- Dark Mode: Cores escuras para economia de bateria
- ThemeService sincroniza tema em toda a app com Provider

### 8. **Validação & Segurança**
- Validation_service para validar inputs
- Feedback visual de erro em formulários

---

## Como Executar

### Pré-requisitos
- Flutter SDK v3.9.2+
- Dart SDK (incluído no Flutter)
- Xcode (macOS/iOS)
- Android Studio/NDK (Android)
- VSCode ou Android Studio como IDE

### Setup Inicial

```bash
# 1. Clone o repositório
git clone https://github.com/raphaelolimpio/Comunit.git
cd Comunit

# 2. Instale dependências
flutter pub get

# 3. Configure variáveis de ambiente
# Crie um arquivo .env na raiz com:
# API_URL=seu_backend_url
# GOOGLE_CLIENT_ID=seu_google_client_id
# Etc.

# 4. Gere ícone da app (opcional)
flutter pub run flutter_launcher_icons:main

# 5. Execute testes
flutter test

# 6. Execute em desenvolvimento
flutter run                          # Detecta dispositivo automaticamente
flutter run -d chrome                # Web
flutter run -d macos                 # macOS
flutter run -d windows               # Windows
flutter run -d linux                 # Linux
```

### Build para Produção

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

---

## Configuração e Variáveis de Ambiente

### Arquivo `.env`
```
API_BASE_URL=https://api.comunit.app
WEBSOCKET_URL=wss://api.comunit.app/ws
GOOGLE_CLIENT_ID=seu_google_client_id.apps.googleusercontent.com
LIVEKIT_URL=wss://livekit.comunit.app
```

### Carregamento em Runtime
- Utiliza `flutter_dotenv` para carregar `.env` em `main()`
- Acessível via `dotenv.env['API_BASE_URL']` em qualquer lugar

---

## Temas & Estilagem

### Cores (lib/shared/color.dart)

**Light Mode:**
- `primaryColor`: Azul (#004fff)
- `backgroundColor`: Branco com subtom
- `appBarColor`: Cinza claro
- `BlackTextColor`: Preto (#000000)

**Dark Mode:**
- `iconAtivoDark`: Azul claro
- `backGroudDarkColor`: Preto (#121212)
- `icondarkNuttonNavigation`: Cinza escuro (#1F1F1F)
- `WhiteIconColor`: Branco (#FFFFFF)

### ThemeService
- Gerencia troca entre Light/Dark mode
- Usa `ChangeNotifierProvider` para notificar mudanças
- Integrado em `MaterialApp` com `themeMode: themeService.themeMode`

---

## Componentes Principais (Design System)

### Botões
- Buttons customizados com cores e estilos da brand

### Cards
- Card reutilizável para exibir itens de lista

### Formulários
- `IconTextForm`: Campo com ícone integrado
- `codeBlockForm`: Bloco de código com syntax highlighting

### Navegação
- `appBar`: App bar customizada
- `appBarSearch`: App bar com campo de busca
- `Convex Bottom Bar`: Barra de navegação inferior customizada

### Busca
- `searchView`: Widget de busca reutilizável
- Integração com `flutter_typeahead` para sugestões

### Temas
- `Theme_Service.dart`: Centraliza lógica de tema

---

## Fluxo de Autenticação

1. Usuário toca no botão "Login com Google"
2. `auth_service.dart` inicia `GoogleSignIn.signIn()`
3. Sistema abre Google Account Picker
4. App recebe token de autenticação
5. Token é salvo em `SharedPreferences` (cache local)
6. Usuário é redirecionado para `Home_widget`
7. Em logout, token é apagado

---

## Fluxo de Chat em Tempo Real

1. Usuário acessa tela de chat
2. `chat_service.dart` abre conexão WebSocket
3. Mensagens são recebidas em tempo real via `web_socket_channel`
4. Cada mensagem é salva no SQLite (histórico local)
5. UI atualiza via `StreamBuilder` ou `FutureBuilder`
6. Ao desconectar, WebSocket é fechado

---

## Fluxo de Busca de Termos

1. Usuário digita no campo de busca
2. `flutter_typeahead` dispara query em tempo real
3. `termo_service` busca no backend/banco local
4. Resultados aparecem como sugestões (dropdown)
5. Ao tocar em um resultado, abre `Detail_widget`

---

## Estrutura de Dados Principais

### Usuário
```dart
class User {
  String id;
  String nome;
  String email;
  String? fotoPerfil;
  DateTime criadoEm;
}
```

### Termo/Palavra
```dart
class Termo {
  String id;
  String palavra;
  String definicao;
  List<String> exemplos;
  String categoria;
  bool ehFavorito;
}
```

### Tópico
```dart
class Topico {
  String id;
  String titulo;
  String descricao;
  List<Termo> termos;
}
```

### Mensagem de Chat
```dart
class Mensagem {
  String id;
  String usuarioId;
  String conteudo;
  DateTime criadoEm;
}
```

---

## Testes

### Estrutura de Testes
```bash
test/
├── unit/                        # Testes de serviços e lógica
├── widget/                      # Testes de componentes UI
└── integration/                 # Testes end-to-end
```

### Executar Testes
```bash
# Todos os testes
flutter test

# Teste específico
flutter test test/unit/auth_service_test.dart

# Com cobertura
flutter test --coverage
```

---

## Boas Práticas Implementadas

1. **Separação de Responsabilidades:** Service Layer isolado de UI
2. **State Management:** Provider centraliza estado global
3. **Reusabilidade:** Design System com componentes compartilhados
4. **Segurança:** Google Sign-In + WebSocket seguro (wss)
5. **Persistência:** Combinação de SQLite + SharedPreferences
6. **Accessibility:** Material Design com AppBar e BottomNavigationBar
7. **Responsividade:** Suporte a múltiplas plataformas (iOS, Android, Web, Desktop)

---

## Troubleshooting

### Issue: App não conecta ao backend
- Verifique `.env` com URL correta
- Teste conexão WebSocket manualmente
- Verifique certificados SSL (especialmente HTTPS/WSS)

### Issue: Dark mode não funciona
- Limpe build: `flutter clean && flutter pub get`
- Reinicie app
- Verifique `ThemeService` está sendo fornecido via `MultiProvider`

### Issue: LiveKit não conecta
- Verifique URL do LiveKit em `.env`
- Confirme servidor LiveKit está rodando
- Teste token de acesso

### Issue: SQLite não persiste dados
- Verifique permissões de storage (especialmente Android)
- Confirme inicialização do banco em `Config/db`
- Teste em emulador vs dispositivo real

---

## Roadmap & Melhorias Futuras

- [ ] Integração com backend robusta
- [ ] Push notifications
- [ ] Offline-first synchronization
- [ ] Analytics e crash reporting
- [ ] Unit tests e widget tests completos
- [ ] CI/CD pipeline (GitHub Actions)
- [ ] Documentação de API
- [ ] Guia de contribuição
- [ ] Release notes automáticos

---

## Contato & Suporte

- **Desenvolvedor:** Raphael Olimpio
- **GitHub:** [raphaelolimpio/Comunit](https://github.com/raphaelolimpio/Comunit)
- **Issues:** [GitHub Issues](https://github.com/raphaelolimpio/Comunit/issues)

---

## Licença

Sem licença especificada. Verifique repositório para detalhes.

---

**Última atualização:** 25 de agosto de 2026
**Versão do Projeto:** 1.0.0+1
