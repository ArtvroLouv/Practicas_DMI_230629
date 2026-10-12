import 'package:flutter/material.dart';

class MenuItem { // 1. Cambiado de MenuItems a MenuItem (singular para que coincida)
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const MenuItem({ // 2. Quitado el corchete '(' sobrante después del nombre del constructor
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon,
  });
}

const appMenuItems = <MenuItem>[ // 3. Usar el tipo MenuItem en la lista
  MenuItem(
    title: 'Botones',
    subTitle: 'Varios botones en flutter',
    link: '/buttons',
    icon: Icons.smart_button_outlined, // 4. Corregido 'Icon.smart_button_outlined' por 'Icons.smart_button_outlined'
  ),
  MenuItem(
    title: 'Tarjetas',
    subTitle: 'Un contenedor estilizado',
    link: '/cards',
    icon: Icons.credit_card,
  ),
];