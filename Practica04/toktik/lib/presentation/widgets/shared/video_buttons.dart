import 'dart:math' as math;
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:toktik/config/helpers/human_formats.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/services/local_storage_service.dart';

class VideoButtons extends StatefulWidget {
  final VideoPost video;
  final bool isMuted;
  final VoidCallback onToggleMute;

  const VideoButtons({
    super.key,
    required this.video,
    required this.isMuted,
    required this.onToggleMute,
  });

  @override
  State<VideoButtons> createState() => _VideoButtonsState();
}

class _VideoButtonsState extends State<VideoButtons>
    with SingleTickerProviderStateMixin {
  late final AnimationController _discController;

  @override
  void initState() {
    super.initState();
    _discController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _discController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      widget.video.isLiked = !widget.video.isLiked;
      if (widget.video.isLiked) {
        widget.video.likes++;
      } else {
        widget.video.likes = (widget.video.likes > 0) ? widget.video.likes - 1 : 0;
      }
    });
    LocalStorageService.saveVideoData(widget.video);
    LocalStorageService.toggleFavorite(widget.video.id, widget.video.isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Avatar del creador con botón "+"
        _CreatorAvatar(username: widget.video.username),
        const SizedBox(height: 18),

        // 2. Botón de Me Gusta
        _ActionButton(
          icon: widget.video.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          iconColor: widget.video.isLiked ? const Color(0xFFFF2A6D) : Colors.white,
          count: widget.video.likes,
          hasHeartbeat: widget.video.isLiked,
          onTap: _toggleLike,
        ),
        const SizedBox(height: 16),

        // 3. Botón de Comentarios
        _ActionButton(
          icon: Icons.chat_bubble_outline_rounded,
          iconColor: Colors.white,
          count: widget.video.comments,
          onTap: () {},
        ),
        const SizedBox(height: 16),

        // 4. Botón de Vistas
        _ActionButton(
          icon: Icons.remove_red_eye_outlined,
          iconColor: Colors.white,
          count: widget.video.views,
          onTap: () {},
        ),
        const SizedBox(height: 16),

        // 5. Botón de Audio Mute/Unmute
        _ActionButton(
          icon: widget.isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
          iconColor: widget.isMuted ? const Color(0xFFFF6B6B) : const Color(0xFF00E5FF),
          onTap: widget.onToggleMute,
        ),
        const SizedBox(height: 18),

        // 6. Disco musical giratorio estilo vinilo
        _RotatingMusicDisc(controller: _discController),
      ],
    );
  }
}

class _CreatorAvatar extends StatelessWidget {
  final String username;

  const _CreatorAvatar({required this.username});

  @override
  Widget build(BuildContext context) {
    final initial = username.replaceAll('@', '').isNotEmpty
        ? username.replaceAll('@', '')[0].toUpperCase()
        : 'U';

    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFFF3366), Color(0xFF00E5FF)],
            ),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -7,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Color(0xFFFF3366),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final int? count;
  final bool hasHeartbeat;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.iconColor,
    this.count,
    this.hasHeartbeat = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Icon(icon, color: iconColor, size: 30);
    if (hasHeartbeat) {
      iconWidget = Bounce(
        duration: const Duration(milliseconds: 350),
        child: iconWidget,
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF141622).withValues(alpha: 0.65),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(child: iconWidget),
          ),
        ),
        if (count != null && count! > 0) ...[
          const SizedBox(height: 4),
          Text(
            HumanFormats.humanReadbleNumber(count!.toDouble()),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              shadows: [
                Shadow(color: Colors.black87, blurRadius: 4, offset: Offset(0, 1)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _RotatingMusicDisc extends StatelessWidget {
  final AnimationController controller;

  const _RotatingMusicDisc({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: controller.value * 2 * math.pi,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF161824),
              border: Border.all(
                color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.25),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF3366),
                ),
                child: const Icon(
                  Icons.music_note_rounded,
                  size: 11,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
