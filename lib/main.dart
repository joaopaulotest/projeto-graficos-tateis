import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:vibration/vibration.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const GraficosTateisApp());
}

class GraficosTateisApp extends StatelessWidget {
  const GraficosTateisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gráficos Táteis',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TelaGraficos(),
    );
  }
}

class TelaGraficos extends StatefulWidget {
  const TelaGraficos({super.key});

  @override
  State<TelaGraficos> createState() => _TelaGraficosState();
}

class _TelaGraficosState extends State<TelaGraficos> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _pesquisaController = TextEditingController();
  bool _isListening = false;
  String _entrada = "sin(x)";
  List<Offset> _pontos = [];
  double _xMin = -10, _xMax = 10;
  bool _rastreando = false;
  double _espessuraLinha = 12.0; // Espessura inicial da linha
  bool _vibracaoAtiva = false;
  bool _sobreReta = false;
  bool _desenhoConcluido = false;
  String _formaGerada = "";
  Offset _ultimaPosicao = Offset.zero;

  @override
  void initState() {
    super.initState();
    _inicializarTTS();
    _carregarAudio();
    _calcularPontos();
    _solicitarPermissaoMicrofone();
  }

  void _inicializarTTS() async {
    await _tts.setLanguage('pt-BR');
    await _tts.setSpeechRate(0.8);
  }

  void _falar(String texto) async {
    await Future.delayed(const Duration(milliseconds: 200));
    await _tts.speak(texto);
  }

  Future<void> _carregarAudio() async {
    try {
      await _audioPlayer.setAsset('assets/sounds/bip.mp3');
    } catch (e) {
      print('Erro ao carregar áudio: $e');
    }
  }

  Future<void> _solicitarPermissaoMicrofone() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  Future<void> _iniciarReconhecimento() async {
    if (!_isListening) {
      bool disponivel = await _speech.initialize();
      if (disponivel) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _entrada = result.recognizedWords;
              _controller.text = _entrada;
              _processarEntrada(_entrada);
            });
          },
        );
      } else {
        _falar("Reconhecimento de voz não disponível.");
      }
    } else {
      _pararReconhecimento();
    }
  }

  void _pararReconhecimento() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _processarEntrada(String entrada) {
    setState(() {
      _entrada = entrada;
      _controller.text = entrada;
    });

    final comandos = {
      RegExp(r'triângulo retângulo'): _gerarTrianguloRetangulo,
      RegExp(r'círculo'): () => _gerarCirculo(raio: 5),
      RegExp(r'quadrado'): () => _gerarQuadrado(lado: 5),
      RegExp(r'retângulo'): () => _gerarRetangulo(largura: 8, altura: 4),
      RegExp(r'pentágono'): () => _gerarPoligonoRegular(lados: 5, raio: 5),
      RegExp(r'hexágono'): () => _gerarPoligonoRegular(lados: 6, raio: 5),
      RegExp(r'heptágono'): () => _gerarPoligonoRegular(lados: 7, raio: 5),
      RegExp(r'octógono'): () => _gerarPoligonoRegular(lados: 8, raio: 5),
      RegExp(r'losango'): () => _gerarLosango(largura: 6, altura: 4),
      RegExp(r'trapézio'): () =>
          _gerarTrapezio(baseMaior: 8, baseMenor: 4, altura: 5),
      RegExp(r'paralelogramo'): () =>
          _gerarParalelogramo(largura: 6, altura: 4, inclinacao: 2),
      RegExp(r'decágono'): () => _gerarPoligonoRegular(lados: 10, raio: 5),
      RegExp(r'dodecágono'): () => _gerarPoligonoRegular(lados: 12, raio: 5),
      RegExp(r'elipse'): () => _gerarElipse(raioX: 6, raioY: 4),
      RegExp(r'trapézio isósceles'): () =>
          _gerarTrapezioIsosceles(baseMaior: 8, baseMenor: 4, altura: 5),
      RegExp(r'trapézio retângulo'): () =>
          _gerarTrapezioRetangulo(baseMaior: 8, baseMenor: 4, altura: 5),
      RegExp(r'cubo'): () => _gerarCubo(lado: 5),
      RegExp(r'esfera'): () => _gerarEsfera(raio: 5),
      RegExp(r'cilindro'): () => _gerarCilindro(raio: 3, altura: 8),
      RegExp(r'cone'): () => _gerarCone(raio: 4, altura: 6),
      RegExp(r'pirâmide'): () => _gerarPiramide(base: 6, altura: 8),
    };

    for (var entry in comandos.entries) {
      if (entry.key.hasMatch(entrada.toLowerCase())) {
        entry.value();
        return;
      }
    }
    _calcularPontos();
  }

  void _gerarTrianguloRetangulo() {
    _gerarForma(
      pontos: [Offset(0, 0), Offset(5, 0), Offset(0, 5), Offset(0, 0)],
      descricao: 'Triângulo retângulo gerado com catetos de 5 unidades',
    );
    _formaGerada = "Triângulo Retângulo"; // Atualiza a forma gerada
  }

  void _gerarCirculo({required double raio}) {
    final pontos = List.generate(36, (index) {
      double angulo = 2 * pi * index / 36;
      return Offset(raio * cos(angulo), raio * sin(angulo));
    });

    _gerarForma(
      pontos: pontos,
      descricao: 'Círculo gerado com raio $raio unidades',
    );
    _formaGerada = "Círculo"; // Atualiza a forma gerada
  }

  void _gerarQuadrado({required double lado}) {
    _gerarForma(
      pontos: [
        Offset(0, 0),
        Offset(lado, 0),
        Offset(lado, lado),
        Offset(0, lado),
        Offset(0, 0),
      ],
      descricao: 'Quadrado gerado com lado $lado unidades',
    );
    _formaGerada = "Quadrado"; // Atualiza a forma gerada
  }

  void _gerarRetangulo({required double largura, required double altura}) {
    _gerarForma(
      pontos: [
        Offset(0, 0),
        Offset(largura, 0),
        Offset(largura, altura),
        Offset(0, altura),
        Offset(0, 0),
      ],
      descricao: 'Retângulo gerado com largura $largura e altura $altura',
    );
    _formaGerada = "Retângulo"; // Atualiza a forma gerada
  }

  void _gerarPoligonoRegular({required int lados, required double raio}) {
    final pontos = List.generate(lados + 1, (index) {
      double angulo = 2 * pi * index / lados;
      return Offset(raio * cos(angulo), raio * sin(angulo));
    });

    _gerarForma(
      pontos: pontos,
      descricao: 'Polígono regular de $lados lados gerado',
    );
    _formaGerada = "Polígono Regular"; // Atualiza a forma gerada
  }

  void _gerarLosango({required double largura, required double altura}) {
    _gerarForma(
      pontos: [
        Offset(0, 0),
        Offset(largura / 2, altura / 2),
        Offset(largura, 0),
        Offset(largura / 2, -altura / 2),
        Offset(0, 0),
      ],
      descricao: 'Losango gerado com largura $largura e altura $altura',
    );
    _formaGerada = "Losango"; // Atualiza a forma gerada
  }

  void _gerarTrapezio({
    required double baseMaior,
    required double baseMenor,
    required double altura,
  }) {
    _gerarForma(
      pontos: [
        Offset(0, 0),
        Offset(baseMaior, 0),
        Offset(baseMaior - (baseMaior - baseMenor) / 2, altura),
        Offset((baseMaior - baseMenor) / 2, altura),
        Offset(0, 0),
      ],
      descricao:
          'Trapézio gerado com base maior $baseMaior, base menor $baseMenor e altura $altura',
    );
    _formaGerada = "Trapézio"; // Atualiza a forma gerada
  }

  void _gerarTrapezioIsosceles({
    required double baseMaior,
    required double baseMenor,
    required double altura,
  }) {
    _gerarTrapezio(baseMaior: baseMaior, baseMenor: baseMenor, altura: altura);
    _falar("Trapézio isósceles gerado.");
    _formaGerada = "Trapézio Isósceles"; // Atualiza a forma gerada
  }

  void _gerarTrapezioRetangulo({
    required double baseMaior,
    required double baseMenor,
    required double altura,
  }) {
    _gerarForma(
      pontos: [
        Offset(0, 0),
        Offset(baseMaior, 0),
        Offset(baseMaior, altura),
        Offset(baseMenor, altura),
        Offset(0, 0),
      ],
      descricao: 'Trapézio retângulo gerado',
    );
    _formaGerada = "Trapézio Retângulo"; // Atualiza a forma gerada
  }

  void _gerarParalelogramo({
    required double largura,
    required double altura,
    required double inclinacao,
  }) {
    _gerarForma(
      pontos: [
        Offset(0, 0),
        Offset(largura, 0),
        Offset(largura + inclinacao, altura),
        Offset(inclinacao, altura),
        Offset(0, 0),
      ],
      descricao: 'Paralelogramo gerado',
    );
    _formaGerada = "Paralelogramo"; // Atualiza a forma gerada
  }

  void _gerarElipse({required double raioX, required double raioY}) {
    final pontos = List.generate(36, (index) {
      double angulo = 2 * pi * index / 36;
      return Offset(raioX * cos(angulo), raioY * sin(angulo));
    });

    _gerarForma(
      pontos: pontos,
      descricao: 'Elipse gerada com raio X $raioX e raio Y $raioY',
    );
    _formaGerada = "Elipse"; // Atualiza a forma gerada
  }

  void _gerarCubo({required double lado}) {
    _gerarForma(
      pontos: [
        Offset(0, 0),
        Offset(lado, 0),
        Offset(lado, lado),
        Offset(0, lado),
        Offset(0, 0),
        Offset(lado / 2, lado / 2),
        Offset(lado * 1.5, lado / 2),
        Offset(lado * 1.5, lado * 1.5),
        Offset(lado / 2, lado * 1.5),
        Offset(lado / 2, lado / 2),
      ],
      descricao: 'Cubo gerado com lado $lado',
    );
    _formaGerada = "Cubo"; // Atualiza a forma gerada
  }

  void _gerarEsfera({required double raio}) {
    _gerarCirculo(raio: raio);
    _falar("Esfera gerada com raio $raio");
    _formaGerada = "Esfera"; // Atualiza a forma gerada
  }

  void _gerarCilindro({required double raio, required double altura}) {
    _gerarForma(
      pontos: [
        Offset(0, 0),
        Offset(altura, 0),
        Offset(altura, raio * 2),
        Offset(0, raio * 2),
        Offset(0, 0),
      ],
      descricao: 'Cilindro gerado com raio $raio e altura $altura',
    );
    _formaGerada = "Cilindro"; // Atualiza a forma gerada
  }

  void _gerarCone({required double raio, required double altura}) {
    _gerarForma(
      pontos: [
        Offset(0, 0),
        Offset(altura, 0),
        Offset(altura / 2, raio * 2),
        Offset(0, 0),
      ],
      descricao: 'Cone gerado com raio $raio e altura $altura',
    );
    _formaGerada = "Cone"; // Atualiza a forma gerada
  }

  void _gerarPiramide({required double base, required double altura}) {
    _gerarForma(
      pontos: [
        Offset(0, 0),
        Offset(base, 0),
        Offset(base / 2, altura),
        Offset(0, 0),
      ],
      descricao: 'Pirâmide gerada com base $base e altura $altura',
    );
    _formaGerada = "Pirâmide"; // Atualiza a forma gerada
  }

  void _gerarForma(
      {required List<Offset> pontos, required String descricao}) async {
    setState(() {
      _pontos = pontos;
      _desenhoConcluido = false;
    });
    _falar(descricao);
  }

  void _tocarAudio() async {
    try {
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play();
      print("Bip tocado."); // Log para depuração
    } catch (e) {
      print('Erro ao tocar áudio: $e');
    }
  }

  void _vibrarMelhorado() async {
    if (_vibracaoAtiva) return;
    _vibracaoAtiva = true;

    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      await Vibration.vibrate(pattern: [100, 100, 100]); // Vibração mais rápida
      print("Vibração ativada.");
    } else {
      print("Dispositivo não suporta vibração.");
    }

    Future.delayed(const Duration(milliseconds: 2000), () {
      _vibracaoAtiva = false;
    });
  }

  void _calcularPontos() {
    _pontos.clear();
    Parser p = Parser();
    Expression exp = p.parse(_entrada);
    ContextModel cm = ContextModel();
    for (double x = _xMin; x <= _xMax; x += 0.1) {
      cm.bindVariable(Variable('x'), Number(x));
      double y = exp.evaluate(EvaluationType.REAL, cm);
      _pontos.add(Offset(x, y));
    }
    setState(() {});
  }

  double _calcularDistanciaDoGrafico(Offset position) {
    double menorDistancia = double.infinity;
    for (int i = 0; i < _pontos.length - 1; i++) {
      Offset ponto1 = _pontos[i];
      Offset ponto2 = _pontos[i + 1];
      double distancia = _distanciaPontoParaLinha(position, ponto1, ponto2);
      if (distancia < menorDistancia) {
        menorDistancia = distancia;
      }
    }
    return menorDistancia;
  }

  double _distanciaPontoParaLinha(Offset ponto, Offset linha1, Offset linha2) {
    double numerador = (linha2.dy - linha1.dy) * ponto.dx -
        ((linha2.dx - linha1.dx) * ponto.dy +
            linha2.dx * linha1.dy -
            linha2.dy * linha1.dx);

    double denominador =
        sqrt(pow(linha2.dy - linha1.dy, 2) + pow(linha2.dx - linha1.dx, 2));

    return numerador.abs() / denominador; // Retorna a distância
  }

  String _calcularDirecao(Offset position) {
    if (_pontos.isEmpty) return "Continue";

    double menorDistancia = double.infinity;
    Offset pontoMaisProximo = Offset.zero;

    for (var ponto in _pontos) {
      double distancia = (ponto - position).distance;
      if (distancia < menorDistancia) {
        menorDistancia = distancia;
        pontoMaisProximo = ponto;
      }
    }

    if (position.dx < pontoMaisProximo.dx) {
      return "Para a esquerda";
    } else if (position.dx > pontoMaisProximo.dx) {
      return "Para a direita";
    } else if (position.dy < pontoMaisProximo.dy) {
      return "Para baixo";
    } else if (position.dy > pontoMaisProximo.dy) {
      return "Para cima";
    }
    return "Continue";
  }

  void _rastrearGrafico(Offset position) async {
    double distancia = _calcularDistanciaDoGrafico(position);

    // Aumenta a sensibilidade do toque na linha (3 pixels)
    if (distancia < 3) {
      if (!_sobreReta) {
        _sobreReta = true;
        _vibrarMelhorado();
        _tocarAudio();
        _falar("Sobre a linha"); // Feedback verbal adicional
      }
    } else {
      if (_sobreReta) {
        _sobreReta = false;
        _falar("Fora da linha"); // Feedback ao sair da linha
      }
      String direcao = _calcularDirecao(position);
      _falar(direcao);
    }

    // Verificação de conclusão mais precisa
    if (_pontos.isNotEmpty) {
      final ultimoPonto = _pontos.last;
      if ((position.dx - ultimoPonto.dx).abs() < 5 &&
          (position.dy - ultimoPonto.dy).abs() < 5) {
        if (!_desenhoConcluido) {
          _desenhoConcluido = true;
          _vibrarMelhorado();
          _tocarAudio();
          _falar(
              "Desenho concluído com sucesso! Forma: $_formaGerada"); // Feedback sobre a forma gerada
        }
      }
    }
  }

  // Método para gerar uma forma aleatória
  void _gerarFormaAleatoria() {
    final random = Random();
    int formaAleatoria = random.nextInt(10); // Gera um número de 0 a 9

    switch (formaAleatoria) {
      case 0:
        _gerarCirculo(raio: random.nextDouble() * 10 + 1); // Raio entre 1 e 10
        break;
      case 1:
        _gerarQuadrado(lado: random.nextDouble() * 10 + 1); // Lado entre 1 e 10
        break;
      case 2:
        _gerarRetangulo(
            largura: random.nextDouble() * 10 + 1,
            altura:
                random.nextDouble() * 10 + 1); // Largura e altura entre 1 e 10
        break;
      case 3:
        _gerarTrianguloRetangulo(); // Triângulo fixo
        break;
      case 4:
        _gerarPoligonoRegular(
            lados: 5, raio: random.nextDouble() * 5 + 1); // Pentágono
        break;
      case 5:
        _gerarLosango(
            largura: random.nextDouble() * 10 + 1,
            altura: random.nextDouble() * 10 + 1); // Losango
        break;
      case 6:
        _gerarTrapezio(
            baseMaior: random.nextDouble() * 10 + 1,
            baseMenor: random.nextDouble() * 10 + 1,
            altura: random.nextDouble() * 10 + 1); // Trapézio
        break;
      case 7:
        _gerarElipse(
            raioX: random.nextDouble() * 10 + 1,
            raioY: random.nextDouble() * 10 + 1); // Elipse
        break;
      case 8:
        _gerarCubo(lado: random.nextDouble() * 10 + 1); // Cubo
        break;
      case 9:
        _gerarEsfera(raio: random.nextDouble() * 10 + 1); // Esfera
        break;
    }
  }

  // Método para mostrar ajuda
  void _mostrarAjuda() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _pesquisaController =
            TextEditingController();
        final TextEditingController _feedbackController =
            TextEditingController();

        return AlertDialog(
          title: const Text("Ajuda"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Como usar o aplicativo:\n\n"
                    "1. Descreva a forma desejada no campo de texto.\n"
                    "2. Toque na tela para rastrear o gráfico.\n"
                    "3. Use o botão de microfone para comandos de voz.\n"
                    "4. O botão de formas aleatórias gera uma figura geométrica.\n"
                    "5. Ao tocar na linha azul, você receberá feedback tátil e sonoro.\n"
                    "6. Quando concluir o desenho, a voz informará 'Você concluiu'.\n\n"
                    "Pesquise por ajuda:"),
                const SizedBox(height: 10),
                // Campo de pesquisa
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _pesquisaController,
                        decoration: const InputDecoration(
                          labelText: 'Buscar ajuda',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          _buscarAjuda(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Botão de buscar
                    ElevatedButton(
                      onPressed: () {
                        _buscarAjuda(_pesquisaController.text);
                      },
                      child: const Text("Buscar"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Campo de feedback
                TextField(
                  controller: _feedbackController,
                  decoration: const InputDecoration(
                    labelText: 'Seu feedback',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    _falar("Feedback enviado: $value");
                    _feedbackController.clear(); // Limpa o campo após enviar
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  // Método para buscar ajuda
  void _buscarAjuda(String pesquisa) {
    _falar("Buscando informações sobre: $pesquisa");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráficos Táteis'),
        actions: [
          Semantics(
            label: "Reconhecimento de voz",
            button: true,
            child: IconButton(
              icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
              onPressed: () async {
                await _iniciarReconhecimento();
                _falar(_isListening
                    ? "Microfone ativado"
                    : "Microfone desativado");
              },
            ),
          ),
          Semantics(
            label: "Gerar forma aleatória",
            button: true,
            child: IconButton(
              icon: const Icon(Icons.shuffle),
              onPressed: () {
                _gerarFormaAleatoria();
                _falar("Gerando nova forma aleatória");
              },
            ),
          ),
          Semantics(
            label: "Ajuda",
            button: true,
            child: IconButton(
              icon: const Icon(Icons.help),
              onPressed: () {
                _mostrarAjuda();
                _falar("Abrindo menu de ajuda");
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    label: "Campo para descrever formas",
                    textField: true,
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Descreva a forma desejada',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) => _processarEntrada(value),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Semantics(
                  label: "Confirmar entrada",
                  button: true,
                  child: ElevatedButton(
                    onPressed: () {
                      _processarEntrada(_controller.text);
                      _falar("Processando comando");
                    },
                    child: const Text("Enter"),
                  ),
                ),
              ],
            ),
          ),
          // Slider para ajustar a espessura da linha
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const Text("Ajustar espessura da linha"),
                Slider(
                  value: _espessuraLinha,
                  min: 1.0,
                  max: 20.0,
                  divisions: 19,
                  onChanged: (value) {
                    setState(() {
                      _espessuraLinha = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Semantics(
              label: "Área de desenho interativa",
              child: GestureDetector(
                onPanStart: (_) => setState(() => _rastreando = true),
                onPanEnd: (_) => setState(() {
                  _rastreando = false;
                  _sobreReta = false;
                }),
                onPanUpdate: (details) =>
                    _rastrearGrafico(details.localPosition),
                child: SfCartesianChart(
                  primaryXAxis: NumericAxis(interval: 2),
                  primaryYAxis: NumericAxis(interval: 2),
                  series: [
                    LineSeries<Offset, double>(
                      dataSource: _pontos,
                      xValueMapper: (ponto, _) => ponto.dx,
                      yValueMapper: (ponto, _) => ponto.dy,
                      width: _espessuraLinha, // Espessura ajustável da linha
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
