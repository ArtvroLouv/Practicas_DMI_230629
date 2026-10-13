import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:toktik/config/helpers/logo_helper.dart'; // Asegúrate de que coincida tu ruta
import 'package:toktik/presentation/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _progress = 0;
  String _statusText = 'Iniciando sistema multimedia...';
  Timer? _timer;

  // Obtenemos el tema de la temporada actual según la fecha
  //general
  final SeasonTheme _seasonTheme = LogoHelper.getCurrentSeasonTheme();
  //aniversario
  //final SeasonTheme _seasonTheme = LogoHelper.getCurrentSeasonTheme(DateTime(2026, 10, 5));
  //Halloween
  //final SeasonTheme _seasonTheme = LogoHelper.getCurrentSeasonTheme(DateTime(2026, 10, 31));
  //Navidad
  //final SeasonTheme _seasonTheme = LogoHelper.getCurrentSeasonTheme(DateTime(2026, 12, 25));
  //san valentin
  //final SeasonTheme _seasonTheme = LogoHelper.getCurrentSeasonTheme(DateTime(2027, 2, 14));

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _playSeasonSound();
    _startSimulatedLoading();
  }

  Future<void> _playSeasonSound() async {
    try {
      // Reproduce el sonido correspondiente a la temporada actual (removiendo 'assets/' si audioplayers lo requiere)
      final soundFile = _seasonTheme.soundPath.replaceFirst('assets/', '');
      await _audioPlayer.play(AssetSource(soundFile));
    } catch (e) {
      debugPrint("Error al reproducir el sonido de temporada: $e");
    }
  }

  void _startSimulatedLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 25), (timer) {
      if (!mounted) return;
      setState(() {
        _progress += 1;
        if (_progress == 25) {
          _statusText = 'Conectando con servidores de streaming...';
        } else if (_progress == 65) {
          _statusText = 'Optimizando códecs de video vertical...';
        } else if (_progress == 90) {
          _statusText = 'Sincronizando feeds y preferencias...';
        } else if (_progress >= 100) {
          _progress = 100;
          _statusText = '¡Bienvenido a TokTik!';
          timer.cancel();
          _goToHome();
        }
      });
    });
  }

  void _goToHome() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 650),
          pageBuilder: (_, _, _) => const HomeScreen(),
          transitionsBuilder: (_, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Extraemos los colores del gradiente del tema actual
    final gradientColors = _seasonTheme.gradientColors;
    final glowColor = _seasonTheme.glowColor;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFF07080C),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Resplandor radial dinámico basado en los colores de temporada
            Positioned(
              top: -80,
              right: -60,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      gradientColors.first.withValues(alpha: 0.25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -80,
              child: Container(
                width: 360,
                height: 360,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      gradientColors.last.withValues(alpha: 0.20),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Contenido central
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo / Emblema adaptado con la imagen de temporada
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final scale = 1.0 + 0.05 * _pulseController.value;
                      final glow = 0.4 + 0.5 * _pulseController.value;
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 115,
                          height: 115,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: gradientColors,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: glowColor.withValues(alpha: glow),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0), // Borde interno
                            child: ClipOval(
                              child: Transform.scale(
                                scale: _seasonTheme.cropScale,
                                child: Image.asset(
                                  _seasonTheme.logoPath,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Nombre de la marca
                  const Text(
                    'TOKTIK',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4.5,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Color(0xFFFF3366),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Tagline
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: glowColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'NEXT-GEN VERTICAL VIDEO FEED',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.2,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // Ecualizador animado
                  _AnimatedSoundbars(
                      controller: _pulseController, glowColor: glowColor),
                ],
              ),
            ),

            // Barra de progreso inferior
            Positioned(
              left: 36,
              right: 36,
              bottom: 50,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _statusText,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$_progress%',
                        style: TextStyle(
                          color: glowColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: 5,
                      color: Colors.white.withValues(alpha: 0.12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: _progress / 100.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradientColors,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedSoundbars extends StatelessWidget {
  final AnimationController controller;
  final Color glowColor;

  const _AnimatedSoundbars(
      {required this.controller, required this.glowColor});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final val = controller.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _bar(12 + 16 * val),
            const SizedBox(width: 5),
            _bar(24 - 12 * val),
            const SizedBox(width: 5),
            _bar(14 + 18 * (1 - val)),
            const SizedBox(width: 5),
            _bar(20 + 10 * val),
            const SizedBox(width: 5),
            _bar(10 + 14 * val),
          ],
        );
      },
    );
  }

  Widget _bar(double height) {
    return Container(
      width: 3.5,
      height: height.clamp(8.0, 32.0),
      decoration: BoxDecoration(
        color: glowColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}