import 'package:flutter/material.dart';
import '../estilo.dart';
import '../models.dart';


class ItemTransacao extends StatelessWidget {
  final Transacao t;
  const ItemTransacao({super.key, required this.t});

  @override
  Widget build(BuildContext context) {
    final cor = t.receita ? verdeReceita : vermelhoDespesa;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
          backgroundColor: cor.withValues(alpha: 0.15),
          child: Icon(iconeCategoria(t.categoria), color: cor)),
      title: Text(t.titulo),
      subtitle: Text('${t.categoria} • ${dataBr(t.data)}'),
      trailing: Text('${t.receita ? '+' : '-'} ${moeda(t.valor)}',
          style: TextStyle(color: cor, fontWeight: FontWeight.bold)),
    );
  }
}
