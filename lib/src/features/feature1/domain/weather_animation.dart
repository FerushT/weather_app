import 'package:flutter/material.dart';

class SunConfig {
  final double width;
  final double blurSigma;
  final BlurStyle blurStyle;
  final bool isLeftLocation;
  final Color coreColor;
  final Color midColor;
  final Color outColor;
  final int animMidMill;
  final int animOutMill;

  SunConfig({
    required this.width,
    required this.blurSigma,
    required this.blurStyle,
    required this.isLeftLocation,
    required this.coreColor,
    required this.midColor,
    required this.outColor,
    required this.animMidMill,
    required this.animOutMill,
  });
}

class CloudConfig {
  final double size;
  final Color color;
  final IconData icon;
  final Widget? widgetCloud;
  final double x;
  final double y;
  final double scaleBegin;
  final double scaleEnd;
  final Curve scaleCurve;
  final double slideX;
  final double slideY;
  final int slideDurMill;
  final Curve slideCurve;

  CloudConfig({
    required this.size,
    required this.color,
    required this.icon,
    this.widgetCloud,
    required this.x,
    required this.y,
    required this.scaleBegin,
    required this.scaleEnd,
    required this.scaleCurve,
    required this.slideX,
    required this.slideY,
    required this.slideDurMill,
    required this.slideCurve,
  });
}

class WrapperScene extends StatefulWidget {
  final Size sizeCanvas;
  final bool isLeftCornerGradient;
  final List<Color> colors;
  final List<Widget> children;

  const WrapperScene({
    super.key,
    required this.sizeCanvas,
    required this.isLeftCornerGradient,
    required this.colors,
    required this.children,
  });

  @override
  _WrapperSceneState createState() => _WrapperSceneState();
}

class _WrapperSceneState extends State<WrapperScene> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: widget.sizeCanvas.width,
          height: widget.sizeCanvas.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: widget.isLeftCornerGradient
                  ? Alignment.topLeft
                  : Alignment.topRight,
              end: Alignment.bottomCenter,
              colors: widget.colors,
            ),
          ),
          child: Stack(
            children: widget.children,
          ),
        ),
      ),
    );
  }
}

class WeatherAnimation extends StatefulWidget {
  const WeatherAnimation({super.key});

  @override
  _WeatherAnimationState createState() => _WeatherAnimationState();
}

class _WeatherAnimationState extends State<WeatherAnimation>
    with TickerProviderStateMixin {
  late AnimationController _sunController;
  late Animation<double> _sunAnimation;

  late AnimationController _cloudController;
  late Animation<double> _cloudScaleAnimation;
  late Animation<double> _cloudSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Sonnenanimation
    _sunController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _sunAnimation = Tween<double>(begin: 80, end: 100).animate(
      CurvedAnimation(parent: _sunController, curve: Curves.easeInOut),
    );

    // Wolkenanimation
    _cloudController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _cloudScaleAnimation = Tween<double>(begin: 0.8, end: 0.7).animate(
      CurvedAnimation(parent: _cloudController, curve: Curves.easeInOut),
    );

    _cloudSlideAnimation = Tween<double>(begin: -50, end: 50).animate(
      CurvedAnimation(parent: _cloudController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _sunController.dispose();
    _cloudController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 124, 189, 242),
              Color.fromARGB(238, 169, 216, 238),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Wolkenanimation
            AnimatedBuilder(
              animation: _cloudController,
              builder: (context, child) {
                return Stack(
                  children: [
                    Positioned(
                      left: 20 + _cloudSlideAnimation.value,
                      top: 100,
                      child: Transform.scale(
                        scale: _cloudScaleAnimation.value,
                        child: Icon(
                          Icons.cloud,
                          size: 220,
                          color: Colors.blue.withOpacity(0.5),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20 + _cloudSlideAnimation.value,
                      top: 150,
                      child: Transform.scale(
                        scale: _cloudScaleAnimation.value,
                        child: Icon(
                          Icons.cloud,
                          size: 160,
                          color: Color.fromARGB(255, 75, 127, 169)
                              .withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            // Sonnenanimation
            AnimatedBuilder(
              animation: _sunAnimation,
              builder: (context, child) {
                return Positioned(
                  top: 20,
                  right: 20,
                  child: Icon(
                    Icons.wb_sunny,
                    size: _sunAnimation.value,
                    color: Colors.yellow,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
