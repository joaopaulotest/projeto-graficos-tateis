# Termo de Abertura do Projeto - Gráficos Táteis

## Informações do Projeto
- **Gestor do Projeto**: João Paulo Calixto da Silva [joao.paulo.calixto08@aluno.ifce.edu.br]
- **Patrocinador**: Henrique Leitão [henriqueleitao@ifce.edu.br]

## Histórico de Revisão
| Data | Versão | Descrição | Autor |
|------|---------|-----------|--------|
| 30/03/2025 | 1.0 | Criação do documento | João Paulo Calixto da Silva |

## 1. Descrição Resumida da Demanda
### Necessidade
Desenvolver uma ferramenta tecnológica que permita a pessoas com deficiência visual acessar conceitos matemáticos visuais (gráficos e formas geométricas) por meio de feedback tátil e auditivo, superando as barreiras educacionais existentes.

### Justificativa
- 6,5 milhões de brasileiros com deficiência visual (IBGE, 2020)
- Falta de soluções acessíveis para ensino de matemática visual
- Alinhamento com ODS 4 (Educação Inclusiva) e LBI 13.146/2015

## 2. Stakeholders do Projeto
| Stakeholder | Interesse |
|------------|-----------|
| Pessoas com deficiência visual | Acesso equitativo ao ensino de matemática |
| Professores de matemática | Ferramenta pedagógica inclusiva |
| Instituições de ensino | Cumprimento de políticas de acessibilidade |
| Desenvolvedores | Criação de tecnologia assistiva inovadora |

## 3. Solução
Aplicativo Móvel "Gráficos Táteis" com as seguintes funcionalidades:
- Geração de gráficos matemáticos (ex: y = x²) com feedback tátil (vibração) e auditivo (descrição em áudio)
- Exploração de formas geométricas 2D (círculo, quadrado, triângulo) por toque na tela
- Compatibilidade com leitores de tela (TalkBack, VoiceOver)

### 3.1 Tecnologias a serem Utilizadas
| Tecnologia | Finalidade |
|------------|------------|
| Flutter | Desenvolvimento (Android) |
| Syncfusion Flutter Charts | Geração de gráficos interativos |
| Flutter TTS | Conversão de texto em fala |
| Speech to Text | Reconhecimento de comandos por voz |
| Vibration | Feedback tátil personalizado |

## 4. Protótipo do Projeto
- Link do Protótipo de Baixa Fidelidade: [A ser inserido]

### Funcionalidades Prototipadas
- Tela inicial com opções de entrada (voz ou texto)
- Exemplo de gráfico de função quadrática com pontos de vibração e voz para auxílio na direção correta

## 5. Escopo
### 5.1 Requisitos Funcionais
| ID | Descrição |
|----|-----------|
| RF01 | Permitir entrada de funções matemáticas via voz ou texto |
| RF02 | Gerar gráficos 2D com feedback tátil (vibração em pontos-chave) |
| RF03 | Descrever características do gráfico (eixos, pontos críticos) por áudio |

### 5.2 Requisitos Não Funcionais
| ID | Descrição |
|----|-----------|
| RNF01 | Tempo de resposta do sistema ≤ 2 segundos para comandos de voz |
| RNF02 | Compatibilidade com Android 10+ e iOS 14+ |

### 5.3 Não Escopo
- Gráficos 3D ou funções trigonométricas complexas
- Integração com plataformas de ensino remoto (Moodle, Google Classroom)

## 6. Especificação da Interface
### Tela de Login
A tela de login será projetada para ser simples, acessível e compatível com leitores de tela.

#### Elementos da Tela
1. **Título da Página**
   - Texto: "Bem-vindo ao Gráficos Táteis"
   - Localização: Topo da tela, centralizado
   - Feedback Auditivo: Leitor de tela informa "Bem-vindo ao Gráficos Táteis"

2. **Campos de Entrada**
   - Campo de E-mail
     - Placeholder: "Digite seu e-mail"
     - Validação: "Formato de e-mail inválido"
     - Feedback Tátil: Vibração rápida em caso de erro
   - Campo de Senha
     - Placeholder: "Digite sua senha"
     - Validação: "Senha incorreta"
     - Feedback Tátil: Vibração longa para erro de autenticação

3. **Botões**
   - Botão de Login
     - Texto: "Entrar"
     - Feedback Tátil: Vibração curta ao toque
   - Botão de Recuperação de Senha
     - Texto: "Esqueceu sua senha?"
   - Botão de Cadastro
     - Texto: "Criar Conta"
     - Feedback Tátil: Vibração curta ao toque
