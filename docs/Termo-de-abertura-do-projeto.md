# GRÁFICOS TÁTEIS: FERRAMENTA INCLUSIVA PARA O ENSINO DE MATEMÁTICA

## Informações do Projeto
**Gestor do Projeto**: João Paulo Calixto da Silva - joao.paulo.calixto08@aluno.ifce.edu.br  
**Patrocinador**: Henrique Leitão - henriqueleitao@ifce.edu.br

## Histórico de Revisão
| Data | Versão | Descrição | Autor |
|------|---------|-----------|--------|
| 30/03/2025 | 1.0 | Criação do documento | João Paulo Calixto da Silva |
| 11/04/2025 | 1.1 | Atualização do documento com todas as seções | João Paulo Calixto da Silva |

## 1. DESCRIÇÃO RESUMIDA DA DEMANDA (NECESSIDADE)

### Necessidade
Desenvolver uma ferramenta tecnológica que permita a pessoas com deficiência visual acessar conceitos matemáticos visuais (gráficos e formas geométricas) por meio de feedback tátil e auditivo, superando as barreiras educacionais existentes.

### Justificativa
- 6,5 milhões de brasileiros com deficiência visual (IBGE, 2020)
- Falta de soluções acessíveis para ensino de matemática visual
- Alinhamento com ODS 4 (Educação Inclusiva) e LBI 13.146/2015
- Necessidade de ferramentas pedagógicas inclusivas no ensino de matemática
- Potencial de impacto na qualidade do ensino para estudantes com deficiência visual

## 2. STAKEHOLDERS DO PROJETO
| Stakeholder | Interesse |
|------------|-----------|
| Pessoas com deficiência visual | Acesso equitativo ao ensino de matemática |
| Professores de matemática | Ferramenta pedagógica inclusiva |
| Instituições de ensino | Cumprimento de políticas de acessibilidade |
| Desenvolvedores | Criação de tecnologia assistiva inovadora |
| Familiares de estudantes | Suporte ao aprendizado |
| Coordenadores pedagógicos | Implementação de práticas inclusivas |

## 3. SOLUÇÃO
Aplicativo Móvel "Gráficos Táteis" com as seguintes funcionalidades:
- Geração de gráficos matemáticos (ex: y = x²) com feedback tátil (vibração) e auditivo (descrição em áudio)
- Exploração de formas geométricas 2D (círculo, quadrado, triângulo) por toque na tela
- Compatibilidade com leitores de tela (TalkBack, VoiceOver)
- Interface adaptativa com alto contraste e elementos ampliados
- Sistema de tutoriais guiados por voz

### 3.1 TECNOLOGIAS A SEREM UTILIZADAS
| Tecnologia | Finalidade |
|------------|------------|
| Flutter | Desenvolvimento multiplataforma (Android/iOS) |
| Syncfusion Flutter Charts | Geração de gráficos interativos |
| Flutter TTS | Conversão de texto em fala |
| Speech to Text | Reconhecimento de comandos por voz |
| Vibration | Feedback tátil personalizado |
| Firebase | Backend e análise de uso |
| GetX | Gerenciamento de estado e rotas |

## 4. PROTÓTIPO DO PROJETO

### 4.1 FUNCIONALIDADES PROTOTIPADAS
1. **Tela Inicial**
   - Menu de navegação acessível
   - Tutorial interativo para novos usuários
   - Últimos gráficos visualizados

2. **Entrada de Funções**
   - Campo de texto com suporte a comandos de voz
   - Teclado matemático adaptado
   - Sugestões de funções comuns

3. **Visualização de Gráficos**
   - Modo de exploração tátil
   - Descrição automática por voz
   - Controles de zoom e navegação
   - Pontos críticos destacados

4. **Formas Geométricas**
   - Biblioteca de formas básicas
   - Modo de desenho guiado
   - Exercícios práticos

## 5. ESCOPO

### 5.1 LISTA DE REQUISITOS FUNCIONAIS
| ID | Descrição | Prioridade |
|----|-----------|------------|
| RF01 | Permitir entrada de funções matemáticas via voz ou texto | Alta |
| RF02 | Gerar gráficos 2D com feedback tátil (vibração em pontos-chave) | Alta |
| RF03 | Descrever características do gráfico por áudio | Alta |
| RF04 | Disponibilizar biblioteca de formas geométricas básicas | Média |
| RF05 | Oferecer tutorial interativo para novos usuários | Média |
| RF06 | Permitir personalização de feedback tátil e sonoro | Média |
| RF07 | Salvar histórico de gráficos explorados | Baixa |
| RF08 | Compartilhar gráficos com outros usuários | Baixa |

### 5.2 LISTA DE REQUISITOS NÃO FUNCIONAIS
| ID | Descrição | Categoria |
|----|-----------|-----------|
| RNF01 | Tempo de resposta do sistema ≤ 2 segundos para comandos de voz | Performance |
| RNF02 | Compatibilidade com Android 10+ e iOS 14+ | Compatibilidade |
| RNF03 | Conformidade com diretrizes WCAG 2.1 nível AAA | Acessibilidade |
| RNF04 | Funcionamento offline para funções básicas | Disponibilidade |
| RNF05 | Proteção de dados conforme LGPD | Segurança |
| RNF06 | Interface adaptável a diferentes tamanhos de tela | Usabilidade |

### 5.3 NÃO ESCOPO
- Gráficos 3D ou funções trigonométricas complexas
- Integração com plataformas de ensino remoto
- Criação de planos de aula ou material didático
- Suporte a sistemas operacionais desktop
- Funcionalidades de rede social

## 6. ESPECIFICAÇÃO DA INTERFACE

### 6.1 DIRETRIZES GERAIS
- Alto contraste em todos os elementos visuais
- Tamanho mínimo de fonte 16px
- Áreas de toque amplas (mínimo 44x44px)
- Feedback sonoro para todas as ações
- Suporte a gestos simples e intuitivos

### 6.2 TELAS PRINCIPAIS

#### 6.2.1 Tela de Login
- Campos: e-mail e senha
- Opção de login por biometria
- Recuperação de senha por áudio
- Tutorial de navegação inicial

#### 6.2.2 Tela Principal
- Menu de navegação inferior com 4 opções:
  - Novo Gráfico
  - Biblioteca de Formas
  - Histórico
  - Configurações
- Barra superior com:
  - Perfil do usuário
  - Ajuda contextual
  - Notificações

#### 6.2.3 Tela de Criação de Gráfico
- Campo de entrada de função
- Botão de comando de voz
- Pré-visualização do gráfico
- Controles de customização:
  - Intensidade da vibração
  - Velocidade da narração
  - Nível de detalhamento

#### 6.2.4 Tela de Exploração
- Área principal para o gráfico
- Minicontroles de navegação
- Informações contextuais
- Opções de compartilhamento

### 6.3 FLUXOS DE NAVEGAÇÃO
1. **Fluxo de Primeiro Acesso**
   - Tela de Boas-vindas
   - Tutorial Interativo
   - Configuração de Preferências
   - Tela Principal

2. **Fluxo de Criação de Gráfico**
   - Seleção do Tipo
   - Entrada de Dados
   - Personalização
   - Exploração
   - Salvamento

3. **Fluxo de Exploração de Forma**
   - Seleção da Forma
   - Tutorial de Gestos
   - Prática Guiada
   - Exercícios

## Links Úteis
- [Repositório do Projeto](https://github.com/joaopaulotest/projeto-graficos-tateis)
- [Sprint I - Termo de Abertura (Project)](https://github.com/joaopaulotest/projeto-graficos-tateis/projects/1)
- [Issues da Sprint I](https://github.com/joaopaulotest/projeto-graficos-tateis/issues?q=is%3Aissue+is%3Aclosed)
