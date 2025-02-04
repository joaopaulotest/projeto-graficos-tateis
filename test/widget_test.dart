import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graficos_tateis/main.dart'; // Verifique se este caminho está correto

void main() {
  testWidgets('Verifica se o aplicativo inicia corretamente',
      (WidgetTester tester) async {
    // Constrói o aplicativo e aciona um quadro.
    await tester.pumpWidget(
        const GraficosTateisApp()); // Use GraficosTateisApp em vez de MyApp

    // Verifica se o campo de entrada está presente.
    expect(find.byType(TextField), findsOneWidget);

    // Verifica se o botão de reconhecimento de voz está presente.
    expect(find.byIcon(Icons.mic), findsOneWidget);

    // Verifica se o botão de confirmação está presente.
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('Verifica se o texto de entrada pode ser modificado',
      (WidgetTester tester) async {
    // Constrói o aplicativo e aciona um quadro.
    await tester.pumpWidget(const GraficosTateisApp()); // Use GraficosTateisApp

    // Encontra o campo de texto.
    final textField = find.byType(TextField);

    // Insere texto no campo de entrada.
    await tester.enterText(textField, 'sin(x)');
    await tester.pump();

    // Verifica se o texto foi inserido corretamente.
    expect(find.text('sin(x)'), findsOneWidget);
  });
}
