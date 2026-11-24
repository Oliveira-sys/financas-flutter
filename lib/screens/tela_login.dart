import 'package:flutter/material.dart';
import '../estilo.dart';
import '../models.dart';


class TelaLogin extends StatefulWidget {
  final AppState estado;
  const TelaLogin({super.key, required this.estado});
  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final nome = TextEditingController();
  final email = TextEditingController();
  final senha = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool oculta = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 38,
                      backgroundColor: verde,
                      child: Icon(Icons.savings_rounded, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    const Text('FinançaClara',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold, color: verde)),
                    const Text('Veja para onde o seu dinheiro vai',
                        style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: nome,
                      decoration: const InputDecoration(
                          labelText: 'Nome',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder()),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Informe seu nome' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.mail_outline),
                          border: OutlineInputBorder()),
                      validator: (v) => (v == null || !v.contains('@'))
                          ? 'E-mail inválido'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: senha,
                      obscureText: oculta,
                      decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(oculta ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => oculta = !oculta),
                          )),
                      validator: (v) => (v == null || v.length < 4)
                          ? 'Mínimo de 4 caracteres'
                          : null,
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: verde),
                        onPressed: () {
                          if (_form.currentState!.validate()) {
                            widget.estado.entrar(nome.text.trim());
                          }
                        },
                        child: const Text('Entrar', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
