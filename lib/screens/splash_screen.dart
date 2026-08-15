import 'package:flutter/material.dart';

class CurioVerseSplashScreen extends StatefulWidget {
  const CurioVerseSplashScreen({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<CurioVerseSplashScreen> createState() => _CurioVerseSplashScreenState();
}

class _CurioVerseSplashScreenState extends State<CurioVerseSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..forward();

  late final Animation<double> scale = CurvedAnimation(
    parent: controller,
    curve: Curves.elasticOut,
  );
  late final Animation<double> fade = CurvedAnimation(
    parent: controller,
    curve: const Interval(0, 0.55, curve: Curves.easeOut),
  );

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 2100), () {
      if (mounted) widget.onFinished();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.2),
            radius: 1.2,
            colors: [
              Color(0xFF5144A8),
              Color(0xFF292065),
              Color(0xFF120C35),
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned(
              top: 80,
              left: 36,
              child: Text('✦', style: TextStyle(color: Color(0xFFFFCB67), fontSize: 28)),
            ),
            const Positioned(
              top: 150,
              right: 42,
              child: Text('✦', style: TextStyle(color: Color(0xFF65D9FF), fontSize: 20)),
            ),
            const Positioned(
              bottom: 170,
              left: 55,
              child: Text('✦', style: TextStyle(color: Color(0xFFFF7A59), fontSize: 18)),
            ),
            Center(
              child: FadeTransition(
                opacity: fade,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: scale,
                      child: Image.asset(
                        'assets/curioverse_logo.webp',
                        width: 230,
                        height: 230,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'CurioVerse',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Big curiosity. Brilliant adventures.',
                      style: TextStyle(
                        color: Color(0xFFDCD8FF),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const SizedBox(
                      width: 110,
                      child: LinearProgressIndicator(
                        color: Color(0xFFFFCB67),
                        backgroundColor: Color(0x405D55A6),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
