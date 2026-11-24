import 'package:flutter/material.dart';
import 'models.dart';
import 'screens/tela_login.dart';
import 'screens/tela_principal.dart';

final estado = AppState();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  estado.carregar();
  runApp(const FinancaClaraApp());
}

class FinancaClaraApp extends StatelessWidget {
  const FinancaClaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinançaClara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0B5D4B), brightness: Brightness.light),
        scaffoldBackgroundColor: const Color(0xFFF5F7F6),
      ),
      home: ListenableBuilder(
        listenable: estado,
        builder: (context, _) {
          if (!estado.carregado) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return estado.usuario == null
              ? TelaLogin(estado: estado)
              : TelaPrincipal(estado: estado);
        },
      ),
    );
  }
}
