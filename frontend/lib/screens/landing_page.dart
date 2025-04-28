import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:system_monitoring_project/widgets/neo_button.dart';
import 'dart:math' as math;

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;

  // Particle system variables
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.02 * math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    // Initialize particles
    for (int i = 0; i < 100; i++) {
      _particles.add(_createParticle());
    }
  }

  Particle _createParticle() {
    return Particle(
      position: Offset(
        _random.nextDouble() * 1500,
        _random.nextDouble() * 1000,
      ),
      velocity: Offset(
        (_random.nextDouble() - 0.5) * 0.8,
        (_random.nextDouble() - 0.5) * 0.8,
      ),
      color:
          _random.nextBool()
              ? const Color(
                0xFF4ECDC4,
              ).withOpacity(_random.nextDouble() * 0.5 + 0.1)
              : Colors.white.withOpacity(_random.nextDouble() * 0.3 + 0.1),
      size: _random.nextDouble() * 4 + 1,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0A0E21),
                  Color(0xFF161A36),
                  Color(0xFF090B16),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Animated particle system
          ParticleSystem(particles: _particles),

          // Background grid pattern
          Opacity(
            opacity: 0.08,
            child: CustomPaint(
              size: Size.infinite,
              painter: FuturisticGridPainter(),
            ),
          ),

          // Hexagon pattern overlay
          Opacity(
            opacity: 0.05,
            child: CustomPaint(
              size: Size.infinite,
              painter: HexagonPatternPainter(),
            ),
          ),

          // Glowing orb effect
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF4ECDC4).withOpacity(0.3),
                    const Color(0xFF4ECDC4).withOpacity(0.0),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),

          // Content
          Center(
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo and title with animated effect
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(seconds: 2),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, (1 - value) * 20),
                            child: Opacity(opacity: value, child: child),
                          );
                        },
                        child: Row(
                          children: [
                            // Animated logo
                            AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle:
                                      math.sin(_controller.value * 10) * 0.05,
                                  child: ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return const LinearGradient(
                                        colors: [
                                          Color(0xFF4ECDC4),
                                          Color(0xFF00FFCC),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ).createShader(bounds);
                                    },
                                    child: const Icon(
                                      Icons.insights,
                                      color: Colors.white,
                                      size: 48,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 16),
                            ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  colors: [Colors.white, Color(0xFFE0E0E0)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ).createShader(bounds);
                              },
                              child: const Text(
                                'NEUROSYS',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 4,
                                ),
                              ),
                            ),
                            ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  colors: [
                                    Color(0xFF4ECDC4),
                                    Color(0xFF00FFCC),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ).createShader(bounds);
                              },
                              child: const Text(
                                ' MONITOR',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Cyberpunk divider
                      Center(
                        child: Container(
                          width: 200,
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Colors.transparent,
                                Color(0xFF4ECDC4),
                                Colors.transparent,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Animated subtitle
                      DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: Colors.white70,
                        ),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              'Advanced system monitoring for the modern era.',
                              speed: const Duration(milliseconds: 70),
                            ),
                          ],
                          isRepeatingAnimation: false,
                          onFinished: () {
                            // Show blinking cursor effect after text completes
                            setState(() {});
                          },
                        ),
                      ),

                      const SizedBox(height: 64),

                      // Features with staggered animation
                      FutureBuilder(
                        future: Future.delayed(
                          const Duration(milliseconds: 300),
                        ),
                        builder: (context, snapshot) {
                          return AnimatedOpacity(
                            opacity:
                                snapshot.connectionState == ConnectionState.done
                                    ? 1.0
                                    : 0.0,
                            duration: const Duration(milliseconds: 800),
                            child: Row(
                              children: [
                                Expanded(
                                  child: FuturisticFeatureCard(
                                    icon: Icons.speed_outlined,
                                    title: 'Real-time Metrics',
                                    description:
                                        'Monitor CPU, memory and system performance in real-time with dynamic visualizations.',
                                    delayFactor: 0,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: FuturisticFeatureCard(
                                    icon: Icons.notifications_active_outlined,
                                    title: 'Intelligent Alerts',
                                    description:
                                        'Get notified immediately when your system exceeds normal operating parameters.',
                                    delayFactor: 1,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: FuturisticFeatureCard(
                                    icon: Icons.insights_outlined,
                                    title: 'Advanced Analytics',
                                    description:
                                        'Analyze historical data and identify patterns to optimize system performance.',
                                    delayFactor: 2,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 80),

                      // CTA buttons with hover effects
                      FutureBuilder(
                        future: Future.delayed(
                          const Duration(milliseconds: 800),
                        ),
                        builder: (context, snapshot) {
                          return AnimatedOpacity(
                            opacity:
                                snapshot.connectionState == ConnectionState.done
                                    ? 1.0
                                    : 0.0,
                            duration: const Duration(milliseconds: 800),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FuturisticButton(
                                    text: 'ENTER DASHBOARD',
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/dashboard',
                                      );
                                    },
                                    isPrimary: true,
                                  ),
                                  const SizedBox(width: 24),
                                  FuturisticButton(
                                    text: 'VIEW ALERTS',
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/alerts');
                                    },
                                    isPrimary: false,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Floating data points effect
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 100,
              child: CustomPaint(
                painter: DataStreamPainter(),
                size: Size.infinite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FuturisticFeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final int delayFactor;

  const FuturisticFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.delayFactor,
  });

  @override
  State<FuturisticFeatureCard> createState() => _FuturisticFeatureCardState();
}

class _FuturisticFeatureCardState extends State<FuturisticFeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: 200 * widget.delayFactor), () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 50),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovering = true;
            _controller.forward();
          });
        },
        onExit: (_) {
          setState(() {
            _isHovering = false;
            _controller.reverse();
          });
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1D1E33).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    _isHovering
                        ? const Color(0xFF4ECDC4).withOpacity(0.6)
                        : Colors.white.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      _isHovering
                          ? const Color(0xFF4ECDC4).withOpacity(0.15)
                          : Colors.transparent,
                  blurRadius: 12,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Animated icon
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors:
                          _isHovering
                              ? const [Color(0xFF4ECDC4), Color(0xFF00FFCC)]
                              : const [Color(0xFF4ECDC4), Color(0xFF4ECDC4)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Icon(widget.icon, color: Colors.white, size: 36),
                ),

                // Animated highlight line
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  height: 2,
                  width: _isHovering ? 60 : 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          _isHovering
                              ? const [Color(0xFF4ECDC4), Color(0xFF00FFCC)]
                              : [
                                Color(0xFF4ECDC4),
                                // ignore: deprecated_member_use
                                Color(0xFF4ECDC4).withOpacity(0.3),
                              ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FuturisticButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const FuturisticButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isPrimary,
  });

  @override
  State<FuturisticButton> createState() => _FuturisticButtonState();
}

class _FuturisticButtonState extends State<FuturisticButton>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow:
                  _isHovering && widget.isPrimary
                      ? [
                        BoxShadow(
                          color: const Color(
                            0xFF4ECDC4,
                          ).withOpacity(0.3 * _glowAnimation.value),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                      : [],
            ),
            child: child,
          );
        },
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            decoration: BoxDecoration(
              color:
                  widget.isPrimary
                      ? _isHovering
                          ? const Color(0xFF4ECDC4)
                          : const Color(0xFF4ECDC4).withOpacity(0.85)
                      : _isHovering
                      ? const Color(0xFF1D1E33).withOpacity(0.95)
                      : const Color(0xFF1D1E33).withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    widget.isPrimary
                        ? const Color(
                          0xFF4ECDC4,
                        ).withOpacity(_isHovering ? 0.9 : 0.6)
                        : Colors.white.withOpacity(_isHovering ? 0.3 : 0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.text,
                  style: TextStyle(
                    color:
                        widget.isPrimary
                            ? Colors.black
                            : _isHovering
                            ? Colors.white
                            : Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  widget.isPrimary ? Icons.arrow_forward : Icons.notifications,
                  color:
                      widget.isPrimary
                          ? Colors.black
                          : Colors.white.withOpacity(0.9),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FuturisticGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..strokeWidth = 0.5;

    // Draw horizontal lines with varying opacity
    for (double y = 0; y < size.height; y += 20) {
      final opacity = (y % 60 == 0) ? 0.2 : 0.1;
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw vertical lines with varying opacity
    for (double x = 0; x < size.width; x += 20) {
      final opacity = (x % 60 == 0) ? 0.2 : 0.1;
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw perspective lines for depth
    paint.color = Colors.white.withOpacity(0.05);
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for (int i = 0; i < 12; i++) {
      final angle = i * math.pi / 6;
      final x = centerX + math.cos(angle) * size.width;
      final y = centerY + math.sin(angle) * size.height;
      canvas.drawLine(Offset(centerX, centerY), Offset(x, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HexagonPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.05)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8;

    const double hexSize = 40;
    final double width = size.width;
    final double height = size.height;

    // Calculate hex dimensions
    final double h = hexSize * math.sqrt(3) / 2;

    for (double x = -hexSize; x < width + hexSize; x += hexSize * 1.5) {
      bool oddRow = false;
      for (double y = -hexSize; y < height + hexSize; y += h) {
        final double offsetX = oddRow ? hexSize * 0.75 : 0;
        drawHexagon(canvas, Offset(x + offsetX, y), hexSize, paint);
        oddRow = !oddRow;
      }
    }
  }

  void drawHexagon(Canvas canvas, Offset center, double size, Paint paint) {
    final Path path = Path();
    for (int i = 0; i < 6; i++) {
      final double angle = (i * 60 + 30) * math.pi / 180;
      final double x = center.dx + size * math.cos(angle);
      final double y = center.dy + size * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DataStreamPainter extends CustomPainter {
  final List<DataPoint> _dataPoints = [];
  final Random _random = Random();

  DataStreamPainter() {
    // Generate random data points
    for (int i = 0; i < 20; i++) {
      _dataPoints.add(
        DataPoint(
          position: Offset(
            _random.nextDouble() * 1500,
            _random.nextDouble() * 80,
          ),
          velocity: Offset(_random.nextDouble() * -2 - 1, 0),
          size: _random.nextDouble() * 3 + 1,
          opacity: _random.nextDouble() * 0.7 + 0.3,
        ),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Update data points
    for (var point in _dataPoints) {
      point.position = point.position.translate(
        point.velocity.dx,
        point.velocity.dy,
      );

      // Reset position if off screen
      if (point.position.dx < 0) {
        point.position = Offset(
          size.width + _random.nextDouble() * 100,
          _random.nextDouble() * 80,
        );
      }

      // Draw data point
      final paint =
          Paint()
            ..color = const Color(0xFF4ECDC4).withOpacity(point.opacity)
            ..style = PaintingStyle.fill;

      canvas.drawCircle(point.position, point.size, paint);

      // Draw trail
      final trailPaint =
          Paint()
            ..color = const Color(0xFF4ECDC4).withOpacity(point.opacity * 0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = point.size * 0.8;

      final path = Path();
      path.moveTo(point.position.dx, point.position.dy);
      path.lineTo(point.position.dx + 15, point.position.dy);

      canvas.drawPath(path, trailPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DataPoint {
  Offset position;
  Offset velocity;
  double size;
  double opacity;

  DataPoint({
    required this.position,
    required this.velocity,
    required this.size,
    required this.opacity,
  });
}

class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double size;

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
  });
}

class ParticleSystem extends StatefulWidget {
  final List<Particle> particles;

  const ParticleSystem({super.key, required this.particles});

  @override
  State<ParticleSystem> createState() => _ParticleSystemState();
}

class _ParticleSystemState extends State<ParticleSystem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        // Update particle positions
        for (var particle in widget.particles) {
          particle.position = particle.position.translate(
            particle.velocity.dx,
            particle.velocity.dy,
          );

          // Wrap particles around screen
          if (particle.position.dx < 0) {
            particle.position = Offset(1500, particle.position.dy);
          } else if (particle.position.dx > 1500) {
            particle.position = Offset(0, particle.position.dy);
          }

          if (particle.position.dy < 0) {
            particle.position = Offset(particle.position.dx, 1000);
          } else if (particle.position.dy > 1000) {
            particle.position = Offset(particle.position.dx, 0);
          }
        }

        return CustomPaint(
          size: Size.infinite,
          painter: ParticlePainter(particles: widget.particles),
        );
      },
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint =
          Paint()
            ..color = particle.color
            ..style = PaintingStyle.fill;

      canvas.drawCircle(particle.position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Random {
  final math.Random _random = math.Random();
  double nextDouble() => _random.nextDouble();
  bool nextBool() => _random.nextBool();
  double nextInt(int max) => _random.nextInt(max).toDouble();
  double nextIntRange(int min, int max) =>
      min + _random.nextInt(max - min).toDouble();
  double nextDoubleRange(double min, double max) =>
      min + _random.nextDouble() * (max - min);
  double nextGaussian() {
    final u = _random.nextDouble();
    final v = _random.nextDouble();
    return math.sqrt(-2 * math.log(u)) * math.cos(2 * math.pi * v);
  }

  double nextGaussianRange(double mean, double stddev) {
    return mean + stddev * nextGaussian();
  }
}

// class Random {
//   final math.Random _random = math.Random();
  
//   double nextDouble() {
//     return _random.nextDouble();
//   }
  
//   bool nextBool() {
//     return _random.nextBool();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:system_monitoring_project/widgets/neo_button.dart';

// class LandingPage extends StatefulWidget {
//   const LandingPage({super.key});

//   @override
//   State<LandingPage> createState() => _LandingPageState();
// }

// class _LandingPageState extends State<LandingPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _opacityAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );

//     _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
//       ),
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.2),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
//       ),
//     );

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background gradient
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Color(0xFF0A0E21), Color(0xFF090B16)],
//               ),
//             ),
//           ),

//           // Background grid pattern
//           Opacity(
//             opacity: 0.1,
//             child: CustomPaint(size: Size.infinite, painter: GridPainter()),
//           ),

//           // Content
//           Center(
//             child: FadeTransition(
//               opacity: _opacityAnimation,
//               child: SlideTransition(
//                 position: _slideAnimation,
//                 child: Container(
//                   constraints: const BoxConstraints(maxWidth: 1200),
//                   padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Logo and title
//                       const Row(
//                         children: [
//                           Icon(
//                             Icons.insights,
//                             color: Color(0xFF4ECDC4),
//                             size: 48,
//                           ),
//                           SizedBox(width: 16),
//                           Text(
//                             'NEUROSYS',
//                             style: TextStyle(
//                               fontSize: 42,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               letterSpacing: 4,
//                             ),
//                           ),
//                           Text(
//                             ' MONITOR',
//                             style: TextStyle(
//                               fontSize: 42,
//                               fontWeight: FontWeight.w300,
//                               color: Color(0xFF4ECDC4),
//                               letterSpacing: 2,
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 32),

//                       // Animated subtitle
//                       DefaultTextStyle(
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.w300,
//                           color: Colors.white70,
//                         ),
//                         child: AnimatedTextKit(
//                           animatedTexts: [
//                             TypewriterAnimatedText(
//                               'Advanced system monitoring for the modern era.',
//                               speed: const Duration(milliseconds: 70),
//                             ),
//                           ],
//                           isRepeatingAnimation: false,
//                         ),
//                       ),

//                       const SizedBox(height: 64),

//                       // Features
//                       Row(
//                         children: [
//                           Expanded(
//                             child: FeatureCard(
//                               icon: Icons.speed_outlined,
//                               title: 'Real-time Metrics',
//                               description:
//                                   'Monitor CPU, memory and system performance in real-time with dynamic visualizations.',
//                             ),
//                           ),
//                           const SizedBox(width: 24),
//                           Expanded(
//                             child: FeatureCard(
//                               icon: Icons.notifications_active_outlined,
//                               title: 'Intelligent Alerts',
//                               description:
//                                   'Get notified immediately when your system exceeds normal operating parameters.',
//                             ),
//                           ),
//                           const SizedBox(width: 24),
//                           Expanded(
//                             child: FeatureCard(
//                               icon: Icons.insights_outlined,
//                               title: 'Advanced Analytics',
//                               description:
//                                   'Analyze historical data and identify patterns to optimize system performance.',
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 80),

//                       // CTA buttons
//                       Center(
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             NeoButton(
//                               text: 'ENTER DASHBOARD',
//                               onPressed: () {
//                                 Navigator.pushNamed(context, '/dashboard');
//                               },
//                               isPrimary: true,
//                             ),
//                             const SizedBox(width: 24),
//                             NeoButton(
//                               text: 'VIEW ALERTS',
//                               onPressed: () {
//                                 Navigator.pushNamed(context, '/alerts');
//                               },
//                               isPrimary: false,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FeatureCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String description;

//   const FeatureCard({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.description,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1D1E33).withOpacity(0.5),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: const Color(0xFF4ECDC4), size: 36),
//           const SizedBox(height: 16),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             description,
//             style: const TextStyle(
//               fontSize: 16,
//               color: Colors.white70,
//               height: 1.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class GridPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint =
//         Paint()
//           ..color = Colors.white.withOpacity(0.1)
//           ..strokeWidth = 0.5;

//     // Draw horizontal lines
//     for (double y = 0; y < size.height; y += 20) {
//       canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
//     }

//     // Draw vertical lines
//     for (double x = 0; x < size.width; x += 20) {
//       canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
