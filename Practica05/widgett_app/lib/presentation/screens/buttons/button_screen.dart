import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonScreen extends StatelessWidget {
  static const String name = 'buttons_screen';

  const ButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Botones Screen'),
      ),
      body: const _ButtonsView(),
    );
  }
}

class _ButtonsView extends StatelessWidget {
  const _ButtonsView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Wrap(
          spacing: 10,
          runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            // 1. Botón ElevatedButton normal
            ElevatedButton(
              onPressed: () {}, 
              child: const Text('Elevated')
            ),

            // 2. Botón ElevatedButton desactivado (onPressed en null)
            const ElevatedButton(
              onPressed: null, 
              child: const Text('Elevated Disabled')
            ),

            // 3. Botón ElevatedButton con icono
            ElevatedButton.icon(
              onPressed: () {}, 
              icon: const Icon(Icons.access_alarm_rounded),
              label: const Text('Elevated Icon'),
            ),

            // 4. Botón de tipo Filled
            FilledButton(
              onPressed: () {}, 
              child: const Text('Filled')
            ),

            // 5. Botón de tipo Filled con icono
            FilledButton.icon(
              onPressed: () {}, 
              icon: const Icon(Icons.accessibility_new),
              label: const Text('Filled Icon'),
            ),

            // 6. Botón Outlined (con borde)
            OutlinedButton(
              onPressed: () {}, 
              child: const Text('Outlined')
            ),

            // 7. Botón Outlined con icono
            OutlinedButton.icon(
              onPressed: () {}, 
              icon: const Icon(Icons.terminal),
              label: const Text('Outlined Icon'),
            ),

            // 8. Botón Text (texto plano)
            TextButton(
              onPressed: () {}, 
              child: const Text('Text')
            ),

            // 9. Botón Text con icono
            TextButton.icon(
              onPressed: () {}, 
              icon: const Icon(Icons.account_box_outlined),
              label: const Text('Text Icon'),
            ),

            // 10. Botón de Icono personalizado
            IconButton(
              onPressed: () {}, 
              icon: const Icon(Icons.app_registration_rounded),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(colors.primary),
                iconColor: const MaterialStatePropertyAll(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}