import 'package:flutter/material.dart';
import '../estilo.dart';
import '../models.dart';


class PaginaMetas extends StatelessWidget {
  final AppState estado;
  const PaginaMetas({super.key, required this.estado});

  Future<double?> _pedirValor(BuildContext context, String titulo) {
    final c = TextEditingController();
    return showDialog<double>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: TextField(
            controller: c,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Valor (R\$)')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(
                  context, double.tryParse(c.text.replaceAll(',', '.'))),
              child: const Text('OK')),
        ],
      ),
    );
  }

  Future<void> _novaMeta(BuildContext context) async {
    final nome = TextEditingController();
    final alvo = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nova meta'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nome, decoration: const InputDecoration(labelText: 'Nome da meta')),
          TextField(
              controller: alvo,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Valor alvo (R\$)')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Criar')),
        ],
      ),
    );
    final v = double.tryParse(alvo.text.replaceAll(',', '.'));
    if (ok == true && nome.text.trim().isNotEmpty && v != null && v > 0) {
      estado.adicionarMeta(nome.text.trim(), v);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: verde,
        foregroundColor: Colors.white,
        onPressed: () => _novaMeta(context),
        icon: const Icon(Icons.add),
        label: const Text('Nova meta'),
      ),
      body: estado.metas.isEmpty
          ? const Center(child: Text('Crie sua primeira meta de economia.'))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
              children: estado.metas.map((m) {
                final p = (m.guardado / m.alvo).clamp(0.0, 1.0);
                return Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                              child: Text(m.nome,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold))),
                          IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => estado.removerMeta(m.id)),
                        ]),
                        Text('${moeda(m.guardado)} de ${moeda(m.alvo)}'),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                              value: p, minHeight: 12, color: verdeReceita, backgroundColor: Colors.black12),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${(p * 100).toStringAsFixed(0)}%'),
                            TextButton.icon(
                              icon: const Icon(Icons.savings),
                              label: const Text('Guardar'),
                              onPressed: () async {
                                final v = await _pedirValor(context, 'Guardar em "${m.nome}"');
                                if (v != null && v > 0) estado.guardarNaMeta(m, v);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
