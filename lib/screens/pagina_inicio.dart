import 'package:flutter/material.dart';
import '../estilo.dart';
import '../models.dart';
import '../widgets/item_transacao.dart';


class PaginaInicio extends StatelessWidget {
  final AppState estado;
  const PaginaInicio({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    final gastos = estado.gastosPorCategoria;
    final maior = gastos.values.fold(0.0, (a, b) => b > a ? b : a);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Olá, ${estado.usuario}!',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: verde, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Saldo atual',
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 4),
              Text(moeda(estado.saldo),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
              child: _Resumo(
                  titulo: 'Receitas',
                  valor: estado.receitas,
                  cor: verdeReceita,
                  icone: Icons.arrow_downward)),
          const SizedBox(width: 12),
          Expanded(
              child: _Resumo(
                  titulo: 'Despesas',
                  valor: estado.despesas,
                  cor: vermelhoDespesa,
                  icone: Icons.arrow_upward)),
        ]),
        const SizedBox(height: 20),
        const Text('Gastos por categoria',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        if (gastos.isEmpty)
          const Text('Nenhuma despesa ainda.')
        else
          ...(gastos.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value)))
              .map((en) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(en.key),
                            Text(moeda(en.value),
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: maior == 0 ? 0 : en.value / maior,
                            minHeight: 10,
                            color: vermelhoDespesa,
                            backgroundColor: Colors.black12,
                          ),
                        ),
                      ],
                    ),
                  )),
        const SizedBox(height: 14),
        const Text('Últimas transações',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ...estado.ordenadas.take(4).map((t) => ItemTransacao(t: t)),
        const SizedBox(height: 70),
      ],
    );
  }
}

class _Resumo extends StatelessWidget {
  final String titulo;
  final double valor;
  final Color cor;
  final IconData icone;
  const _Resumo(
      {required this.titulo,
      required this.valor,
      required this.cor,
      required this.icone});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          CircleAvatar(
              backgroundColor: cor.withValues(alpha: 0.15),
              child: Icon(icone, color: cor)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: const TextStyle(color: Colors.black54)),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(moeda(valor),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
