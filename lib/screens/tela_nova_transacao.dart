import 'package:flutter/material.dart';
import '../estilo.dart';
import '../models.dart';


class TelaNovaTransacao extends StatefulWidget {
  final AppState estado;
  const TelaNovaTransacao({super.key, required this.estado});
  @override
  State<TelaNovaTransacao> createState() => _TelaNovaTransacaoState();
}

class _TelaNovaTransacaoState extends State<TelaNovaTransacao> {
  final _form = GlobalKey<FormState>();
  final titulo = TextEditingController();
  final valor = TextEditingController();
  bool receita = false;
  String categoria = 'Alimentação';
  DateTime data = DateTime.now();

  Future<void> escolherData() async {
    final d = await showDatePicker(
        context: context,
        initialDate: data,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100));
    if (d != null) setState(() => data = d);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: verde,
          foregroundColor: Colors.white,
          title: const Text('Nova transação')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Despesa'), icon: Icon(Icons.arrow_upward)),
                ButtonSegment(value: true, label: Text('Receita'), icon: Icon(Icons.arrow_downward)),
              ],
              selected: {receita},
              onSelectionChanged: (s) => setState(() {
                receita = s.first;
                categoria = receita ? 'Salário' : 'Alimentação';
              }),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: titulo,
              decoration: const InputDecoration(
                  labelText: 'Descrição', border: OutlineInputBorder()),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Informe a descrição' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: valor,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                  labelText: 'Valor (R\$)', border: OutlineInputBorder()),
              validator: (v) {
                final n = double.tryParse((v ?? '').replaceAll(',', '.'));
                return (n == null || n <= 0) ? 'Valor inválido' : null;
              },
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: categoria,
              decoration: const InputDecoration(
                  labelText: 'Categoria', border: OutlineInputBorder()),
              items: categorias
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => categoria = v!),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: escolherData,
              icon: const Icon(Icons.calendar_today),
              label: Text('Data: ${dataBr(data)}'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: verde),
                onPressed: () {
                  if (!_form.currentState!.validate()) return;
                  widget.estado.adicionar(Transacao(
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    titulo: titulo.text.trim(),
                    valor: double.parse(valor.text.replaceAll(',', '.')),
                    receita: receita,
                    categoria: categoria,
                    data: data,
                  ));
                  Navigator.pop(context);
                },
                child: const Text('Salvar', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
