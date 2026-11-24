import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const categorias = [
  'Alimentação',
  'Transporte',
  'Estudos',
  'Lazer',
  'Moradia',
  'Salário',
  'Outros',
];

String moeda(double v) {
  final neg = v < 0;
  final s = v.abs().toStringAsFixed(2);
  final partes = s.split('.');
  final inteiro = partes[0];
  final buf = StringBuffer();
  for (var i = 0; i < inteiro.length; i++) {
    if (i > 0 && (inteiro.length - i) % 3 == 0) buf.write('.');
    buf.write(inteiro[i]);
  }
  return '${neg ? '-' : ''}R\$ $buf,${partes[1]}';
}

String dataBr(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

class Transacao {
  final String id;
  final String titulo;
  final double valor;
  final bool receita;
  final String categoria;
  final DateTime data;

  Transacao({
    required this.id,
    required this.titulo,
    required this.valor,
    required this.receita,
    required this.categoria,
    required this.data,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'valor': valor,
        'receita': receita,
        'categoria': categoria,
        'data': data.toIso8601String(),
      };

  factory Transacao.fromJson(Map<String, dynamic> j) => Transacao(
        id: j['id'],
        titulo: j['titulo'],
        valor: (j['valor'] as num).toDouble(),
        receita: j['receita'],
        categoria: j['categoria'],
        data: DateTime.parse(j['data']),
      );
}

class Meta {
  final String id;
  final String nome;
  final double alvo;
  double guardado;

  Meta({required this.id, required this.nome, required this.alvo, this.guardado = 0});

  Map<String, dynamic> toJson() =>
      {'id': id, 'nome': nome, 'alvo': alvo, 'guardado': guardado};

  factory Meta.fromJson(Map<String, dynamic> j) => Meta(
        id: j['id'],
        nome: j['nome'],
        alvo: (j['alvo'] as num).toDouble(),
        guardado: (j['guardado'] as num).toDouble(),
      );
}

/// Estado global do app. Salva tudo no aparelho com shared_preferences.
class AppState extends ChangeNotifier {
  String? usuario;
  final List<Transacao> transacoes = [];
  final List<Meta> metas = [];
  bool carregado = false;

  Future<void> carregar() async {
    final p = await SharedPreferences.getInstance();
    usuario = p.getString('usuario');
    final t = p.getString('transacoes');
    final m = p.getString('metas');
    if (t != null) {
      transacoes.addAll((jsonDecode(t) as List)
          .map((e) => Transacao.fromJson(e as Map<String, dynamic>)));
    }
    if (m != null) {
      metas.addAll((jsonDecode(m) as List)
          .map((e) => Meta.fromJson(e as Map<String, dynamic>)));
    }
    carregado = true;
    notifyListeners();
  }

  Future<void> _salvar() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(
        'transacoes', jsonEncode(transacoes.map((e) => e.toJson()).toList()));
    await p.setString('metas', jsonEncode(metas.map((e) => e.toJson()).toList()));
    if (usuario != null) await p.setString('usuario', usuario!);
  }

  Future<void> entrar(String nome, {bool exemplo = true}) async {
    usuario = nome;
    if (exemplo && transacoes.isEmpty) _dadosExemplo();
    await _salvar();
    notifyListeners();
  }

  Future<void> sair() async {
    usuario = null;
    final p = await SharedPreferences.getInstance();
    await p.remove('usuario');
    notifyListeners();
  }

  void _dadosExemplo() {
    final hoje = DateTime.now();
    DateTime d(int dias) => hoje.subtract(Duration(days: dias));
    int n = 0;
    Transacao t(String titulo, double v, bool r, String c, int dias) =>
        Transacao(
            id: 'ex${n++}',
            titulo: titulo,
            valor: v,
            receita: r,
            categoria: c,
            data: d(dias));
    transacoes.addAll([
      t('Salário', 2800, true, 'Salário', 4),
      t('Aluguel', 900, false, 'Moradia', 3),
      t('Mercado', 320.5, false, 'Alimentação', 2),
      t('Ônibus', 120, false, 'Transporte', 2),
      t('Cinema', 45, false, 'Lazer', 1),
      t('Curso online', 89.9, false, 'Estudos', 1),
      t('Freela site', 400, true, 'Outros', 0),
    ]);
    metas.add(Meta(id: 'm0', nome: 'Notebook novo', alvo: 3500, guardado: 1200));
  }

  double get receitas =>
      transacoes.where((e) => e.receita).fold(0.0, (a, e) => a + e.valor);
  double get despesas =>
      transacoes.where((e) => !e.receita).fold(0.0, (a, e) => a + e.valor);
  double get saldo => receitas - despesas;

  Map<String, double> get gastosPorCategoria {
    final m = <String, double>{};
    for (final e in transacoes.where((e) => !e.receita)) {
      m[e.categoria] = (m[e.categoria] ?? 0) + e.valor;
    }
    return m;
  }

  List<Transacao> get ordenadas =>
      [...transacoes]..sort((a, b) => b.data.compareTo(a.data));

  void adicionar(Transacao t) {
    transacoes.add(t);
    _salvar();
    notifyListeners();
  }

  void remover(String id) {
    transacoes.removeWhere((e) => e.id == id);
    _salvar();
    notifyListeners();
  }

  void adicionarMeta(String nome, double alvo) {
    metas.add(Meta(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        nome: nome,
        alvo: alvo));
    _salvar();
    notifyListeners();
  }

  void guardarNaMeta(Meta m, double v) {
    m.guardado += v;
    _salvar();
    notifyListeners();
  }

  void removerMeta(String id) {
    metas.removeWhere((e) => e.id == id);
    _salvar();
    notifyListeners();
  }
}
