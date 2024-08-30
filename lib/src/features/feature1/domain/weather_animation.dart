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

class WindConfig {
  final double width;
  final double y;
  final double windGap;
  final double blurSigma;
  final Color color;
  final double slideXStart;
  final double slideXEnd;
  final int pauseStartMill;
  final int pauseEndMill;
  final int slideDurMill;
  final BlurStyle blurStyle;

  WindConfig({
    required this.width,
    required this.y,
    required this.windGap,
    required this.blurSigma,
    required this.color,
    required this.slideXStart,
    required this.slideXEnd,
    required this.pauseStartMill,
    required this.pauseEndMill,
    required this.slideDurMill,
    required this.blurStyle,
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

class WrapperScene extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      width: sizeCanvas.width,
      height: sizeCanvas.height,
      decoration: BoxDecoration(
        gradient: isLeftCornerGradient
            ? LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
      ),
      child: Stack(
        children: children,
      ),
    );
  }
}

class WeatherAnimation extends StatelessWidget {
  const WeatherAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return WrapperScene(
      sizeCanvas: const Size(350, 540),
      isLeftCornerGradient: true,
      colors: const [
        Color(0xff90caf9),
        Color(0xef4fc3f7),
      ],
      children: [
        // Platzhalter für Sonne
        Container(
          alignment: Alignment.topRight,
          child: const Icon(Icons.wb_sunny, size: 100, color: Colors.yellow),
        ),
        // Platzhalter für Wind
        Positioned(
          left: 0,
          top: 200,
          child: Container(
            width: 5,
            height: 200,
            color: Colors.blueGrey,
          ),
        ),
        // Platzhalter für Wolken
        Positioned(
          left: 20,
          top: 35,
          child:
              Icon(Icons.cloud, size: 250, color: Colors.blue.withOpacity(0.5)),
        ),
        Positioned(
          left: 140,
          top: 130,
          child:
              Icon(Icons.cloud, size: 160, color: Colors.blue.withOpacity(0.5)),
        ),
      ],
    );
  }
}
