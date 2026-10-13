import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/presentation/widgets/shared/video_buttons.dart';
import 'package:toktik/presentation/widgets/video/video_background.dart';
import 'package:toktik/presentation/widgets/shared/app_loading_indicator.dart';
import 'package:toktik/presentation/providers/playback_settings.dart';
import 'package:toktik/infrastructure/services/local_storage_service.dart';

class FullScreenPlayer extends StatefulWidget {
  final VideoPost videoPost;
  final bool isActive;

  const FullScreenPlayer({
    super.key,
    required this.videoPost,
    required this.isActive,
  });

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  late VideoPlayerController controller;
  late Future<void> _initializeFuture;
  bool _viewCounted = false;
  bool _showHeartAnimation = false;
  Offset _heartPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    // Bloqueo estricto vertical
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _initController();
  }

  void _initController() {
    controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoPost.videoUrl),
      httpHeaders: const {
        'User-Agent':
            'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
      },
    );
    _initializeFuture = controller
        .initialize()
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException('Tiempo de espera agotado'),
        )
        .then((_) async {
      if (!mounted) return;
      final isMuted = context.read<PlaybackSettings>().isMuted;
      await controller.setVolume(isMuted ? 0 : 1);
      await controller.setLooping(true);
      controller.addListener(_checkVideoProgress);
      if (mounted && widget.isActive) {
        await controller.play();
      }
    });
  }

  void _checkVideoProgress() {
    if (_viewCounted || !controller.value.isPlaying) return;
    if (controller.value.position >= const Duration(seconds: 3)) {
      _viewCounted = true;
      if (mounted) {
        setState(() {
          widget.videoPost.views++;
        });
        LocalStorageService.saveVideoData(widget.videoPost);
      }
    }
  }

  void _retry() {
    controller.removeListener(_checkVideoProgress);
    controller.dispose();
    setState(_initController);
  }

  @override
  void didUpdateWidget(covariant FullScreenPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive &&
        controller.value.isInitialized) {
      final action = widget.isActive ? controller.play() : controller.pause();
      action.then((_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    setState(() {});
  }

  void _handleDoubleTap(TapDownDetails details) {
    setState(() {
      _heartPosition = details.localPosition;
      _showHeartAnimation = true;
      if (!widget.videoPost.isLiked) {
        widget.videoPost.isLiked = true;
        widget.videoPost.likes++;
        LocalStorageService.saveVideoData(widget.videoPost);
        LocalStorageService.toggleFavorite(widget.videoPost.id, true);
      }
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() => _showHeartAnimation = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final playbackSettings = context.watch<PlaybackSettings>();

    if (controller.value.isInitialized) {
      controller.setVolume(playbackSettings.isMuted ? 0 : 1);
    }

    return FutureBuilder(
      future: _initializeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return VideoPlaceholder(
            coverUrl: widget.videoPost.coverUrl,
            showLoader: true,
          );
        }

        if (snapshot.hasError || !controller.value.isInitialized) {
          return Stack(
            children: [
              VideoPlaceholder(coverUrl: widget.videoPost.coverUrl),
              Center(
                child: TextButton.icon(
                  onPressed: _retry,
                  icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                  label: const Text(
                    'Error al reproducir. Reintentar',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        }

        return GestureDetector(
          onTap: _handleTap,
          onDoubleTapDown: _handleDoubleTap,
          child: Container(
            color: Colors.black,
            child: Stack(
              children: [
                // 1. Video vertical centrado
                Center(
                  child: InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 3.5,
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    ),
                  ),
                ),

                // 2. Gradiente inferior cinematográfico
                IgnorePointer(
                  child: VideoBackground(
                    stops: const [0.60, 1.0],
                    colors: const [Colors.transparent, Color(0xE608090C)],
                  ),
                ),

                // 3. Indicador de Pausa moderno
                if (!controller.value.isPlaying)
                  IgnorePointer(
                    child: Center(
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutBack,
                        tween: Tween(begin: 0.7, end: 1.0),
                        builder: (context, scale, child) {
                          return Transform.scale(
                            scale: scale,
                            child: child,
                          );
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF10121A).withValues(alpha: 0.75),
                            border: Border.all(
                              color: const Color(0xFF00E5FF).withValues(alpha: 0.6),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.play_arrow_rounded,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // 4. Animación de corazón al dar doble tap
                if (_showHeartAnimation)
                  Positioned(
                    left: _heartPosition.dx - 45,
                    top: _heartPosition.dy - 45,
                    child: BounceInDown(
                      duration: const Duration(milliseconds: 400),
                      child: Icon(
                        Icons.favorite_rounded,
                        size: 90,
                        color: const Color(0xFFFF2A6D),
                        shadows: const [
                          Shadow(color: Color(0xFFFF2A6D), blurRadius: 25),
                          Shadow(color: Colors.black87, blurRadius: 10),
                        ],
                      ),
                    ),
                  ),

                // 5. Botones interactivos (columna lateral derecha)
                Positioned(
                  bottom: 30,
                  right: 12,
                  child: VideoButtons(
                    video: widget.videoPost,
                    isMuted: playbackSettings.isMuted,
                    onToggleMute: playbackSettings.toggleMute,
                  ),
                ),

                // 6. Información del creador y título (inferior izquierda)
                Positioned(
                  bottom: 26,
                  left: 14,
                  child: _VideoCaption(videoPost: widget.videoPost),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class VideoPlaceholder extends StatelessWidget {
  final String? coverUrl;
  final bool showLoader;

  const VideoPlaceholder({super.key, this.coverUrl, this.showLoader = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF08090C),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (coverUrl != null && coverUrl!.isNotEmpty)
            Image.network(
              coverUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          if (showLoader)
            const Center(
              child: AppLoadingIndicator(
                message: 'Cargando video...',
              ),
            ),
        ],
      ),
    );
  }
}

class _VideoCaption extends StatefulWidget {
  final VideoPost videoPost;

  const _VideoCaption({required this.videoPost});

  @override
  State<_VideoCaption> createState() => _VideoCaptionState();
}

class _VideoCaptionState extends State<_VideoCaption> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Nombre de usuario con insignia de creador
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.videoPost.username,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  letterSpacing: -0.2,
                  shadows: [
                    Shadow(color: Colors.black87, blurRadius: 4, offset: Offset(0, 1)),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.verified_rounded,
                size: 15,
                color: Color(0xFF00E5FF),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Descripción del video
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Text(
              widget.videoPost.caption,
              maxLines: _isExpanded ? null : 2,
              overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                height: 1.35,
                shadows: [
                  Shadow(color: Colors.black87, blurRadius: 4, offset: Offset(0, 1)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Pista musical estilo ticker
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.music_note_rounded,
                size: 14,
                color: Color(0xFFFF9900),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Audio original · ${widget.videoPost.username}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
