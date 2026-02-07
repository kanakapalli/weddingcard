import 'dart:math';

import 'package:flutter/material.dart';

/// A royal, animated splash/loader screen that plays for a few seconds
/// before revealing the wedding invitation.
///
/// Features:
/// - Double ornamental doors that swing open
/// - Gold shimmer text
/// - Decorative flourishes
class RoyalSplashScreen extends StatefulWidget {
  final VoidCallback onComplete;
  final Duration duration;

  const RoyalSplashScreen({
    super.key,
    required this.onComplete,
    this.duration = const Duration(milliseconds: 4500),
  });

  @override
  State<RoyalSplashScreen> createState() => _RoyalSplashScreenState();
}

class _RoyalSplashScreenState extends State<RoyalSplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _doorController;
  late final AnimationController _textController;
  late final AnimationController _shimmerController;

  late final Animation<double> _leftDoorAnim;
  late final Animation<double> _rightDoorAnim;
  late final Animation<double> _textFade;
  late final Animation<double> _textScale;
  late final Animation<double> _ornamentFade;

  @override
  void initState() {
    super.initState();

    // Text & ornament appear first
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _textFade = CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );
    _textScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );
    _ornamentFade = CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    );

    // Shimmer effect
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Doors swing open
    _doorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _leftDoorAnim = Tween<double>(begin: 0.0, end: -1.0).animate(
      CurvedAnimation(parent: _doorController, curve: Curves.easeInOutCubic),
    );
    _rightDoorAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _doorController, curve: Curves.easeInOutCubic),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    // Phase 1: Text & ornaments fade in
    await _textController.forward();
    await Future.delayed(const Duration(milliseconds: 800));

    // Phase 2: Doors swing open
    await _doorController.forward();
    await Future.delayed(const Duration(milliseconds: 400));

    // Done – notify parent
    widget.onComplete();
  }

  @override
  void dispose() {
    _doorController.dispose();
    _textController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF0A0A0A),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background pattern
          _buildBackground(),

          // Center content (text + ornaments)
          _buildCenterContent(),

          // Left door
          AnimatedBuilder(
            animation: _leftDoorAnim,
            builder: (context, child) {
              return _buildDoor(
                alignment: Alignment.centerLeft,
                translateFraction: _leftDoorAnim.value,
                isLeft: true,
              );
            },
          ),

          // Right door
          AnimatedBuilder(
            animation: _rightDoorAnim,
            builder: (context, child) {
              return _buildDoor(
                alignment: Alignment.centerRight,
                translateFraction: _rightDoorAnim.value,
                isLeft: false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            Color(0xFF1A1205),
            Color(0xFF0A0A0A),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterContent() {
    return Center(
      child: FadeTransition(
        opacity: _textFade,
        child: ScaleTransition(
          scale: _textScale,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top ornament
              FadeTransition(
                opacity: _ornamentFade,
                child: _buildOrnament(),
              ),
              const SizedBox(height: 24),

              // "You are invited" text
              AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, _) {
                  return ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: const [
                          Color(0xFFD4A843),
                          Color(0xFFFFF5CC),
                          Color(0xFFD4A843),
                          Color(0xFFFFF5CC),
                          Color(0xFFD4A843),
                        ],
                        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                        begin: Alignment(-2.0 + 4.0 * _shimmerController.value, 0),
                        end: Alignment(2.0 + 4.0 * _shimmerController.value, 0),
                      ).createShader(bounds);
                    },
                    child: const Text(
                      'You Are Invited',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 8,
                        color: Colors.white,
                        fontFamily: 'serif',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Subtitle
              FadeTransition(
                opacity: _ornamentFade,
                child: Text(
                  'TO A ROYAL CELEBRATION',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 6,
                    color: const Color(0xFFD4A843).withValues(alpha: 0.7),
                    fontFamily: 'serif',
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Bottom ornament
              FadeTransition(
                opacity: _ornamentFade,
                child: _buildOrnament(flip: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrnament({bool flip = false}) {
    return Transform(
      alignment: Alignment.center,
      transform: flip ? (Matrix4.identity()..rotateZ(pi)) : Matrix4.identity(),
      child: SizedBox(
        width: 200,
        height: 30,
        child: CustomPaint(
          painter: _OrnamentPainter(color: const Color(0xFFD4A843)),
        ),
      ),
    );
  }

  Widget _buildDoor({
    required Alignment alignment,
    required double translateFraction,
    required bool isLeft,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final doorWidth = constraints.maxWidth / 2;
        return Align(
          alignment: alignment,
          child: Transform.translate(
            offset: Offset(translateFraction * doorWidth, 0),
            child: Container(
              width: doorWidth,
              height: constraints.maxHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: isLeft ? Alignment.centerRight : Alignment.centerLeft,
                  end: isLeft ? Alignment.centerLeft : Alignment.centerRight,
                  colors: const [
                    Color(0xFF1C1608),
                    Color(0xFF0E0B04),
                  ],
                ),
                border: Border(
                  left: isLeft
                      ? BorderSide.none
                      : const BorderSide(color: Color(0xFFD4A843), width: 2),
                  right: isLeft
                      ? const BorderSide(color: Color(0xFFD4A843), width: 2)
                      : BorderSide.none,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.8),
                    blurRadius: 30,
                    offset: Offset(isLeft ? 10 : -10, 0),
                  ),
                ],
              ),
              child: Center(
                child: _buildDoorPanel(isLeft),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDoorPanel(bool isLeft) {
    return Container(
      width: 120,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFD4A843).withValues(alpha: 0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(60),
      ),
      child: Center(
        child: Container(
          width: 80,
          height: 240,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFD4A843).withValues(alpha: 0.15),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
            child: Icon(
              isLeft ? Icons.chevron_left : Icons.chevron_right,
              color: const Color(0xFFD4A843).withValues(alpha: 0.3),
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrnamentPainter extends CustomPainter {
  final Color color;

  _OrnamentPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final midY = size.height / 2;
    final midX = size.width / 2;

    // Center diamond
    final diamondPath = Path()
      ..moveTo(midX, midY - 6)
      ..lineTo(midX + 6, midY)
      ..lineTo(midX, midY + 6)
      ..lineTo(midX - 6, midY)
      ..close();
    canvas.drawPath(diamondPath, paint);

    // Left decorative line with curls
    canvas.drawLine(Offset(midX - 10, midY), Offset(midX - 80, midY), paint);
    // Left curl
    final leftCurl = Path()
      ..moveTo(midX - 80, midY)
      ..quadraticBezierTo(midX - 95, midY - 12, midX - 90, midY + 2);
    canvas.drawPath(leftCurl, paint);

    // Right decorative line with curls
    canvas.drawLine(Offset(midX + 10, midY), Offset(midX + 80, midY), paint);
    // Right curl
    final rightCurl = Path()
      ..moveTo(midX + 80, midY)
      ..quadraticBezierTo(midX + 95, midY - 12, midX + 90, midY + 2);
    canvas.drawPath(rightCurl, paint);

    // Small dots
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(midX - 30, midY), 2, dotPaint);
    canvas.drawCircle(Offset(midX + 30, midY), 2, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
