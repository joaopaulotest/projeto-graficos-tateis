# GRÁFICOS TÁTEIS: FERRAMENTA INCLUSIVA PARA O ENSINO DE MATEMÁTICA

## Informações do Projeto
**Gestor do Projeto**: [João Paulo Calixto da Silva](https://github.com/joaopaulotest) - [joao.paulo.calixto08@aluno.ifce.edu.br](mailto:joao.paulo.calixto08@aluno.ifce.edu.br)  
**Patrocinador**: [Henrique Leitão](mailto:henriqueleitao@ifce.edu.br)

## Histórico de Revisão
| Data | Versão | Descrição | Autor |
|------|---------|-----------|--------|
| 30/03/2025 | 1.0 | Criação do documento | João Paulo Calixto da Silva |

## 1. DESCRIÇÃO RESUMIDA DA DEMANDA (NECESSIDADE)
### Necessidade
Desenvolver uma ferramenta tecnológica que permita a pessoas com deficiência visual acessar conceitos matemáticos visuais (gráficos e formas geométricas) por meio de feedback tátil e auditivo, superando as barreiras educacionais existentes.

### Justificativa
- 6,5 milhões de brasileiros com deficiência visual ([IBGE, 2020](https://www.ibge.gov.br/))
- Falta de soluções acessíveis para ensino de matemática visual
- Alinhamento com [ODS 4 (Educação Inclusiva)](https://brasil.un.org/pt-br/sdgs/4) e [LBI 13.146/2015](http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2015/lei/l13146.htm)

## 2. STAKEHOLDERS DO PROJETO
| Stakeholder | Interesse |
|------------|-----------|
| Pessoas com deficiência visual | Acesso equitativo ao ensino de matemática |
| Professores de matemática | Ferramenta pedagógica inclusiva |
| Instituições de ensino | Cumprimento de políticas de acessibilidade |
| Desenvolvedores | Criação de tecnologia assistiva inovadora |

## 3. SOLUÇÃO
Aplicativo Móvel "Gráficos Táteis" com as seguintes funcionalidades:
- Geração de gráficos matemáticos (ex: y = x²) com feedback tátil (vibração) e auditivo (descrição em áudio)
- Exploração de formas geométricas 2D (círculo, quadrado, triângulo) por toque na tela
- Compatibilidade com leitores de tela ([TalkBack](https://support.google.com/accessibility/android/answer/6283677?hl=pt-BR), [VoiceOver](https://support.apple.com/pt-br/guide/iphone/iph3e2e415f/ios))

### 3.1 TECNOLOGIAS A SEREM UTILIZADAS
| Tecnologia | Finalidade |
|------------|------------|
| [Flutter](https://flutter.dev/) | Desenvolvimento (Android) |
| [Syncfusion Flutter Charts](https://pub.dev/packages/syncfusion_flutter_charts) | Geração de gráficos interativos |
| [Flutter TTS](https://pub.dev/packages/flutter_tts) | Conversão de texto em fala |
| [Speech to Text](https://pub.dev/packages/speech_to_text) | Reconhecimento de comandos por voz |
| [Vibration](https://pub.dev/packages/vibration) | Feedback tátil personalizado |

## 4. PROTÓTIPO DO PROJETO
Link do Protótipo de Baixa Fidelidade: [Figma - Gráficos Táteis](https://www.figma.com/file/projeto-graficos-tateis)

### Funcionalidades Prototipadas
- Tela inicial com opções de entrada (voz ou texto)
- Exemplo de gráfico de função quadrática com pontos de vibração e voz para auxílio na direção correta

## 5. ESCOPO
### 5.1 LISTA DE REQUISITOS FUNCIONAIS
| ID | Descrição |
|----|-----------|
| RF01 | Permitir entrada de funções matemáticas via voz ou texto |
| RF02 | Gerar gráficos 2D com feedback tátil (vibração em pontos-chave) |
| RF03 | Descrever características do gráfico (eixos, pontos críticos) por áudio |

### 5.2 LISTA DE REQUISITOS NÃO FUNCIONAIS
| ID | Descrição |
|----|-----------|
| RNF01 | Tempo de resposta do sistema ≤ 2 segundos para comandos de voz |
| RNF02 | Compatibilidade com Android 10+ e iOS 14+ |

### 5.3 NÃO ESCOPO
- Gráficos 3D ou funções trigonométricas complexas
- Integração com plataformas de ensino remoto ([Moodle](https://moodle.org/), [Google Classroom](https://classroom.google.com/))

## 6. ESPECIFICAÇÃO DA INTERFACE
### Tela de Login
A tela de login do aplicativo Gráficos Táteis será projetada para ser simples, acessível e compatível com leitores de tela (TalkBack e VoiceOver).

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

## Links Úteis
- [Repositório do Projeto](https://github.com/joaopaulotest/Graficos-Tateis)
- [Issues](https://github.com/joaopaulotest/Graficos-Tateis/issues)
- [Milestone da Sprint I](https://github.com/joaopaulotest/Graficos-Tateis/milestones)
