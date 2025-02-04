import 'dart:math';

import 'package:flutter/material.dart';

class Snowfall extends StatefulWidget {
  const Snowfall({super.key});

  @override
  SnowfallState createState() => SnowfallState();
}

class SnowfallState extends State<Snowfall> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final List<Snowflake> _snowflakes = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_snowflakes.isEmpty) {
      for (int i = 0; i < 150; i++) { // Increased snowflakes count
        _snowflakes.add(Snowflake(
          x: Random().nextInt((MediaQuery.of(context).size.width.toInt() * 1.5).round()) + 0.0,
          y: -i * 10,
          size: 2.0 + Random().nextInt(5), // Reduced max size
          speed: 0.5 + Random().nextDouble(),
        ));
      }
    }
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: SnowfallPainter(_snowflakes),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        );
      },
    );
  }
}

class Snowflake {
  double x;
  double y;
  double size;
  double speed;

  Snowflake({required this.x, required this.y, required this.size, required this.speed});

  void update() {
    x -= speed;
    y += speed * 2;
  }
}

class SnowfallPainter extends CustomPainter {
  final List<Snowflake> _snowflakes;

  SnowfallPainter(this._snowflakes);

  @override
  void paint(Canvas canvas, Size size) {
    for (var snowflake in _snowflakes) {
      snowflake.update();
      if (snowflake.x < 0 || snowflake.y > size.height) {
        snowflake.x = Random().nextInt((size.width.toInt() * 1.3).round()) + 0.0;
        snowflake.y = Random().nextInt(100) * -1.0;
      }
      canvas.drawCircle(
        Offset(snowflake.x, snowflake.y),
        snowflake.size,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}