import 'package:flutter/material.dart';
import 'package:yes_no_app/domain/entities/message.dart';

class HerMessageBubble extends StatelessWidget {
  final Message message;

  const HerMessageBubble({
    super.key,
    required this.message,
  });

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0
        ? 12
        : time.hour % 12;

    final minute = time.minute.toString().padLeft(2, '0');

    final period = time.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Text(
            message.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),

        if (message.imageUrl != null) ...[
          const SizedBox(height: 5),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              message.imageUrl!,
              width: MediaQuery.of(context).size.width * 0.7,
              height: 150,
              fit: BoxFit.cover,
              loadingBuilder: (
                context,
                child,
                loadingProgress,
              ) {
                if (loadingProgress == null) {
                  return child;
                }

                return Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 150,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              },
              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 150,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.broken_image,
                  ),
                );
              },
            ),
          ),
        ],

        const SizedBox(height: 4),

        Text(
          _formatTime(message.time),
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 11,
          ),
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}