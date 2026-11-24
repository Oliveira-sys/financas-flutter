import 'package:material_ui/material_ui.dart';


// Cores e ícones usados em todo o app.
const verde = Color(0xFF0B5D4B);
const verdeReceita = Color(0xFF2ECC71);
const vermelhoDespesa = Color(0xFFE74C3C);

IconData iconeCategoria(String c) {
  switch (c) {
    case 'Alimentação':
      return Icons.restaurant;
    case 'Transporte':
      return Icons.directions_bus;
    case 'Estudos':
      return Icons.school;
    case 'Lazer':
      return Icons.movie;
    case 'Moradia':
      return Icons.home;
    case 'Salário':
      return Icons.payments;
    default:
      return Icons.category;
  }
}
