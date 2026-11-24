import 'package:flutter/material.dart';
import '../estilo.dart';
import '../models.dart';
import 'pagina_inicio.dart';
import 'pagina_metas.dart';
import 'pagina_transacoes.dart';
import 'tela_nova_transacao.dart';


class TelaPrincipal extends StatefulWidget {
  final AppState estado;
  const TelaPrincipal({super.key, required this.estado});
  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int aba = 0;

  @override
  Widget build(BuildContext context) {
    final e = widget.estado;
    final paginas = [
      PaginaInicio(estado: e),
      PaginaTransacoes(estado: e),
      PaginaMetas(estado: e),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: verde,
        foregroundColor: Colors.white,
        title: Text(['Início', 'Transações', 'Metas'][aba]),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: e.sair,
          )
        ],
      ),
      body: ListenableBuilder(
          listenable: e, builder: (_, _) => paginas[aba]),
      floatingActionButton: aba == 2
          ? null
          : FloatingActionButton.extended(
              backgroundColor: verde,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Nova'),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => TelaNovaTransacao(estado: e))),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: aba,
        onDestinationSelected: (i) => setState(() => aba = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Transações'),
          NavigationDestination(icon: Icon(Icons.flag_outlined), selectedIcon: Icon(Icons.flag), label: 'Metas'),
        ],
      ),
    );
  }
}
