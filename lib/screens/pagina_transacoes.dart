import 'package:material_ui/material_ui.dart';
import '../estilo.dart';
import '../models.dart';
import '../widgets/item_transacao.dart';


class PaginaTransacoes extends StatefulWidget {
  final AppState estado;
  const PaginaTransacoes({super.key, required this.estado});
  @override
  State<PaginaTransacoes> createState() => _PaginaTransacoesState();
}

class _PaginaTransacoesState extends State<PaginaTransacoes> {
  String filtro = 'Todas';

  @override
  Widget build(BuildContext context) {
    final lista = widget.estado.ordenadas.where((t) {
      if (filtro == 'Receitas') return t.receita;
      if (filtro == 'Despesas') return !t.receita;
      return true;
    }).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: ['Todas', 'Receitas', 'Despesas']
                .map((f) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(f),
                        selected: filtro == f,
                        onSelected: (_) => setState(() => filtro = f),
                      ),
                    ))
                .toList(),
          ),
        ),
        Expanded(
          child: lista.isEmpty
              ? const Center(child: Text('Nenhuma transação.'))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                  itemCount: lista.length,
                  itemBuilder: (_, i) {
                    final t = lista[i];
                    return Dismissible(
                      key: ValueKey(t.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: vermelhoDespesa,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        widget.estado.remover(t.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Transação excluída')));
                      },
                      child: ItemTransacao(t: t),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
