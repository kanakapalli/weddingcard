import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../models/parallax_layer.dart';

/// A widget that renders stacked image layers with a 2.5-D parallax
/// depth effect.
///
/// • **Mobile** – driven by the device gyroscope.
/// • **Web / Desktop** – driven by the mouse cursor position.
class ParallaxDepthScene extends StatefulWidget {
  final List<ParallaxLayer> layers;

  /// Maximum pixel offset applied to the most reactive layer.
  final double maxOffset;

  /// How quickly the animation catches up (lower = smoother).
  final double sensitivity;

  const ParallaxDepthScene({
    super.key,
    required this.layers,
    this.maxOffset = 40.0,
    this.sensitivity = 0.08,
  });

  @override
  State<ParallaxDepthScene> createState() => _ParallaxDepthSceneState();
}

class _ParallaxDepthSceneState extends State<ParallaxDepthScene>
    with SingleTickerProviderStateMixin {
  // Normalised input values in the range [-1, 1].
  double _targetX = 0.0;
  double _targetY = 0.0;

  // Smoothed values that are actually applied.
  double _currentX = 0.0;
  double _currentY = 0.0;

  StreamSubscription<GyroscopeEvent>? _gyroSub;
  late final AnimationController _ticker;

  // Accumulated gyroscope angles (radians).
  double _gyroX = 0.0;
  double _gyroY = 0.0;

  // Clamp range for gyro accumulation (≈ ±15°).
  static const double _gyroClamp = 0.26;

  @override
  void initState() {
    super.initState();

    // Use a ticker to smoothly interpolate towards the target every frame.
    _ticker = AnimationController.unbounded(vsync: this)
      ..addListener(_onTick);

    // Start the ticker by animating it forever.
    _ticker.animateTo(
      double.maxFinite,
      duration: const Duration(days: 365),
    );

    // Always try to init gyroscope – works on native AND mobile web browsers.
    _initGyroscope();
  }

  void _initGyroscope() {
    try {
      _gyroSub = gyroscopeEventStream(
        samplingPeriod: const Duration(milliseconds: 16),
      ).listen(
        (event) {
      // Gyroscope gives angular velocity in rad/s.
      // We accumulate to approximate the current tilt angle.
      _gyroY += event.x * 0.016; // pitch  → vertical shift
      _gyroX += event.y * 0.016; // roll   → horizontal shift

      _gyroX = _gyroX.clamp(-_gyroClamp, _gyroClamp);
      _gyroY = _gyroY.clamp(-_gyroClamp, _gyroClamp);

      _targetX = (_gyroX / _gyroClamp).clamp(-1.0, 1.0);
      _targetY = (_gyroY / _gyroClamp).clamp(-1.0, 1.0);
        },
        onError: (_) {
          // Gyroscope not available (e.g. desktop browser) – fall back to mouse.
          _gyroSub?.cancel();
          _gyroSub = null;
        },
      );
    } catch (_) {
      // Sensor API not supported – silently fall back to mouse/cursor input.
    }
  }

  void _onTick() {
    // Lerp towards the target for a buttery-smooth motion.
    final newX =
        _currentX + (_targetX - _currentX) * widget.sensitivity;
    final newY =
        _currentY + (_targetY - _currentY) * widget.sensitivity;

    if ((newX - _currentX).abs() > 0.0001 ||
        (newY - _currentY).abs() > 0.0001) {
      setState(() {
        _currentX = newX;
        _currentY = newY;
      });
    }
  }

  void _onHover(PointerEvent event, BoxConstraints constraints) {
    // Map the cursor position to [-1, 1].
    final halfW = constraints.maxWidth / 2;
    final halfH = constraints.maxHeight / 2;
    _targetX = ((event.localPosition.dx - halfW) / halfW).clamp(-1.0, 1.0);
    _targetY = ((event.localPosition.dy - halfH) / halfH).clamp(-1.0, 1.0);
  }

  void _onExit(PointerEvent _) {
    // Smoothly return to center when the cursor leaves.
    _targetX = 0;
    _targetY = 0;
  }

  @override
  void dispose() {
    _gyroSub?.cancel();
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Widget scene = Stack(
          clipBehavior: Clip.hardEdge,
          children: widget.layers.asMap().entries.map((entry) {
            final layer = entry.value;
            final offsetX = _currentX * widget.maxOffset * layer.depthFactor;
            final offsetY = _currentY * widget.maxOffset * layer.depthFactor;

            Widget image = Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..translate(offsetX, offsetY + layer.baseOffsetY),
              child: Transform.scale(
                scale: layer.scale,
                child: Image.asset(
                  layer.assetPath,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.medium,
                ),
              ),
            );

            // Optional depth-of-field blur.
            if (layer.blurSigma > 0) {
              image = ImageFiltered(
                imageFilter:
                    ImageFilter.blur(sigmaX: layer.blurSigma, sigmaY: layer.blurSigma),
                child: image,
              );
            }

             return Positioned.fill(child: image);
          }).toList(),
        );

        // On web / desktop, wrap with mouse listener.
        if (kIsWeb) {
          scene = MouseRegion(
            onHover: (e) => _onHover(e, constraints),
            onExit: _onExit,
            child: scene,
          );
        }

        return ClipRect(child: scene);
      },
    );
  }
}
