import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  static const _messages = [
    'Cargando películas...',
    'Preparando las palomitas...',
    'Buscando los estrenos...',
  ];

  Stream<String> _loadingMessages() {
    return Stream<String>.periodic(
      const Duration(milliseconds: 1200),
      (step) => _messages[step % _messages.length],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Espera un momento'),
          const SizedBox(height: 10),
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 10),
          StreamBuilder<String>(
            stream: _loadingMessages(),
            builder: (context, snapshot) =>
                Text(snapshot.data ?? 'Cargando...'),
          ),
        ],
      ),
    );
  }
}
