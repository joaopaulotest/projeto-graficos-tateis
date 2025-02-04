import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:vibration/vibration.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';
import 'package:google_generative_ai/google_generative_ai.dart';
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
  double _espessuraLinha = 12.0;
  bool _vibracaoAtiva = false;
  bool _sobreReta = false;
  bool _desenhoConcluido = false;

  final GenerativeModel _model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: 'AIzaSyDgnxULw84WcNRIUK0fOC1ViMhgiAWDoCM',
  );

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
    await _tts.setSpeechRate(0.4);
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
  }

  void _gerarQuadrado({required double lado}) {
    _gerarForma(
      pontos: [
        Offset(0, 0),
        Offset(lado, 0),
        Offset(lado, lado),
        Offset(0, lado),
        Offset(0, 0)
      ],
      descricao: 'Quadrado gerado com lado $lado unidades',
    );
  }

  void _gerarRetangulo({required double largura, required double altura}) {
    _gerarForma(
      pontos: [
        Offset(0, 0),
        Offset(largura, 0),
        Offset(largura, altura),
        Offset(0, altura),
        Offset(0, 0)
      ],
      descricao: 'Retângulo gerado com largura $largura e altura $altura',
    );
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
  }

  void _gerarLosango({required double largura, required double altura}) {
    _gerarForma(
      pontos: [
        Offset(0, 0),
        Offset(largura / 2, altura / 2),
        Offset(largura, 0),
        Offset(largura / 2, -altura / 2),
        Offset(0, 0)
      ],
      descricao: 'Losango gerado com largura $largura e altura $altura',
    );
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
        Offset(0, 0)
      ],
      descricao:
          'Trapézio gerado com base maior $baseMaior, base menor $baseMenor e altura $altura',
    );
  }

  void _gerarTrapezioIsosceles({
    required double baseMaior,
    required double baseMenor,
    required double altura,
  }) {
    _gerarTrapezio(baseMaior: baseMaior, baseMenor: baseMenor, altura: altura);
    _falar("Trapézio isósceles gerado.");
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
        Offset(0, 0)
      ],
      descricao: 'Trapézio retângulo gerado',
    );
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
        Offset(0, 0)
      ],
      descricao: 'Paralelogramo gerado',
    );
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
  }

  void _gerarEsfera({required double raio}) {
    _gerarCirculo(raio: raio);
    _falar("Esfera gerada com raio $raio");
  }

  void _gerarCilindro({required double raio, required double altura}) {
    _gerarForma(
      pontos: [
        Offset(0, 0),
        Offset(altura, 0),
        Offset(altura, raio * 2),
        Offset(0, raio * 2),
        Offset(0, 0)
      ],
      descricao: 'Cilindro gerado com raio $raio e altura $altura',
    );
  }

  void _gerarCone({required double raio, required double altura}) {
    _gerarForma(
      pontos: [
        Offset(0, 0),
        Offset(altura, 0),
        Offset(altura / 2, raio * 2),
        Offset(0, 0)
      ],
      descricao: 'Cone gerado com raio $raio e altura $altura',
    );
  }

  void _gerarPiramide({required double base, required double altura}) {
    _gerarForma(
      pontos: [
        Offset(0, 0),
        Offset(base, 0),
        Offset(base / 2, altura),
        Offset(0, 0)
      ],
      descricao: 'Pirâmide gerada com base $base e altura $altura',
    );
  }

  void _gerarForma(
      {required List<Offset> pontos, required String descricao}) async {
    setState(() {
      _pontos = pontos;
      _desenhoConcluido = false;
    });
    await _gerarDescricaoGemini(descricao);
  }

  Future<void> _gerarDescricaoGemini(String promptBase) async {
    try {
      final prompt =
          'Descreva de forma acessível para deficientes visuais: $promptBase';
      final response = await _model.generateContent([Content.text(prompt)]);
      _falar(response.text ?? promptBase);
    } catch (e) {
      _falar(promptBase);
    }
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

  void _vibrar({int duracao = 100}) async {
    if (_vibracaoAtiva) return;
    _vibracaoAtiva = true;
    if (await Vibration.hasVibrator() ?? false) {
      await Vibration.vibrate(duration: duracao);
      print("Vibração ativada."); // Log para depuração
    } else {
      print("Vibração não disponível."); // Log para depuração
    }
    Future.delayed(
        Duration(milliseconds: duracao), () => _vibracaoAtiva = false);
  }

  void _falar(String texto) async {
    await _tts.speak(texto);
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

  void _rastrearGrafico(Offset position) async {
    double distancia = _calcularDistanciaDoGrafico(position);
    if (distancia < 10) {
      if (!_sobreReta) {
        _sobreReta = true;
        _vibrar(duracao: 2000); // Vibra por 2 segundos
        _tocarAudio(); // Toca o bip aqui
        print("Vibração ativada ao tocar na linha."); // Log para depuração
      }
    } else {
      _sobreReta = false;
      String direcao = _calcularDirecao(position);
      await _gerarDescricaoGemini(direcao);
    }

    // Verifica se o desenho foi concluído
    if (_pontos.isNotEmpty &&
        position.dx >= _pontos.last.dx - 10 &&
        position.dy >= _pontos.last.dy - 10) {
      if (!_desenhoConcluido) {
        _desenhoConcluido = true;
        _falar("Você concluiu");
      }
    }
  }

  String _calcularDirecao(Offset position) {
    if (position.dx < _pontos.first.dx) {
      return "Para a direita";
    } else if (position.dx > _pontos.last.dx) {
      return "Para a esquerda";
    } else if (position.dy < _pontos.first.dy) {
      return "Para baixo";
    } else if (position.dy > _pontos.last.dy) {
      return "Para cima";
    }
    return "Continue";
  }

  double _calcularDistanciaDoGrafico(Offset pontoToque) {
    double menorDistancia = double.infinity;
    for (int i = 0; i < _pontos.length - 1; i++) {
      Offset ponto1 = _pontos[i];
      Offset ponto2 = _pontos[i + 1];
      double distancia = _distanciaPontoParaLinha(pontoToque, ponto1, ponto2);
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
    return numerador.abs() / denominador;
  }

  void _mostrarAjuda() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajuda"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const Text("Como usar o aplicativo:\n\n"
                    "1. Descreva a forma desejada no campo de texto.\n"
                    "2. Toque na tela para rastrear o gráfico.\n"
                    "3. Use o botão de microfone para comandos de voz.\n"
                    "4. O botão de formas aleatórias gera uma figura geométrica.\n"
                    "5. Ao tocar na linha azul, você receberá feedback tátil e sonoro.\n"
                    "6. Quando concluir o desenho, a voz informará 'Você concluiu'.\n\n"
                    "Pesquise por ajuda:"),
                const SizedBox(height: 20), // Aumentando a distância
                TextField(
                  controller: _pesquisaController,
                  decoration: const InputDecoration(
                    hintText: "Digite sua dúvida...",
                  ),
                ),
                const SizedBox(height: 20), // Aumentando a distância
                const Text("Deixe seu feedback:"),
                TextField(
                  controller: _feedbackController,
                  decoration: const InputDecoration(
                    hintText: "Digite seu feedback...",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () async {
                if (_pesquisaController.text.isNotEmpty) {
                  final prompt = _pesquisaController.text;
                  final response =
                      await _model.generateContent([Content.text(prompt)]);
                  _falar(response.text ??
                      "Não foi possível encontrar uma resposta.");
                  print("Pesquisa processada: $prompt");
                }
              },
              child: const Text("Pesquisar"),
            ),
            OutlinedButton(
              onPressed: () async {
                if (_feedbackController.text.isNotEmpty) {
                  _falar("Feedback enviado com sucesso!");
                  _feedbackController.clear();
                  print("Feedback enviado.");
                }
              },
              child: const Text("Enviar Feedback"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráficos Táteis'),
        actions: [
          IconButton(
            icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
            onPressed: () {
              _iniciarReconhecimento();
              _falar("Ativar ou desativar reconhecimento de voz");
            },
            tooltip: "Ativar/desativar reconhecimento de voz",
          ),
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: () {
              _gerarFormaAleatoria();
              _falar("Gerar forma aleatória");
            },
            tooltip: "Gerar forma aleatória",
          ),
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              _mostrarAjuda();
              _falar("Ajuda e feedback");
            },
            tooltip: "Ajuda e feedback",
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
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Descreva a forma desejada',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      _processarEntrada(value);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _processarEntrada(_controller.text);
                    _falar("Processar entrada");
                  },
                  child: const Text("Enter"),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                if (_rastreando) {
                  _rastrearGrafico(details.localPosition);
                }
              },
              child: SfCartesianChart(
                primaryXAxis: NumericAxis(interval: 2),
                primaryYAxis: NumericAxis(interval: 2),
                series: [
                  LineSeries<Offset, double>(
                    dataSource: _pontos,
                    xValueMapper: (ponto, _) => ponto.dx,
                    yValueMapper: (ponto, _) => ponto.dy,
                    width: _espessuraLinha,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _gerarFormaAleatoria() {
    final formas = [
      "triângulo retângulo",
      "círculo",
      "quadrado",
      "retângulo",
      "pentágono",
      "hexágono",
      "heptágono",
      "octógono",
      "losango",
      "trapézio",
      "paralelogramo",
      "decágono",
      "dodecágono",
      "elipse",
      "trapézio isósceles",
      "trapézio retângulo",
      "cubo",
      "esfera",
      "cilindro",
      "cone",
      "pirâmide",
    ];
    _entrada = formas[Random().nextInt(formas.length)];
    _processarEntrada(_entrada);
  }

  void _vibrarMelhorado() async {
    if (_vibracaoAtiva) return;
    _vibracaoAtiva = true;
    if (await Vibration.hasVibrator() ?? false) {
      await Vibration.vibrate(duration: 1000); // Vibra por 1 segundo
      await Future.delayed(Duration(milliseconds: 500)); // Pausa de 0.5 segundo
      await Vibration.vibrate(duration: 1000); // Vibra por mais 1 segundo
      print("Vibração ativada."); // Log para depuração
    } else {
      print("Vibração não disponível."); // Log para depuração
    }
    Future.delayed(Duration(milliseconds: 2000), () => _vibracaoAtiva = false);
  }
}
