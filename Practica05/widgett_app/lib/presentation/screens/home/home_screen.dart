import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widgett_app/config/menu/menu_items.dart';// Ojo: en los imports de paquetes nunca va '/lib/' en medio

class HomeScreen extends StatelessWidget {
  static const String name = 'home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter + Material 3'),
      ),
      body: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: appMenuItems.length,
      itemBuilder: (context, index) {
        final menuItem = appMenuItems[index];

        // Aquí usamos nuestro widget personalizado en lugar del ListTile plano
        return _CustomListTile(menuItem: menuItem);
      },
    );
  }
}

// Widget personalizado que te faltaba
class _CustomListTile extends StatelessWidget {
  const _CustomListTile({
    required this.menuItem,
  });

  final MenuItem menuItem;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(menuItem.icon, color: colors.primary),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      title: Text(menuItem.title),
      subtitle: Text(menuItem.subTitle),
      onTap: () {
        // Opción 1: Usando la ruta por su path (string)
        context.push(menuItem.link);
        
        // Opción 2 (Alternativa con GoRouter usando el name de la ruta si lo prefieres):
        // context.pushNamed(menuItem.link); 
      },
    );
  }
}