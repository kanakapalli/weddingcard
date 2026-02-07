import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'models/parallax_layer.dart';
import 'widgets/parallax_depth_scene.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wedding Card',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ParallaxHomePage(),
    );
  }
}

/// Full-screen 2.5-D parallax scene built from the five layered
/// images stored in `assets/paralex_img/`.
///
/// The layers are ordered back-to-front (1 → 5) with increasing
/// depth factors so that deeper layers move less, producing the
/// classic parallax / cardboard-cutout 2.5-D illusion.
class ParallaxHomePage extends StatelessWidget {
  const ParallaxHomePage({super.key});

  /// Portrait aspect ratio matching the source images.
  // static const double _portraitAspectRatio = 9 / 16;

  @override
  Widget build(BuildContext context) {
    // Define layers back-to-front (5 is farthest background, 1 is closest foreground).
    const layers = <ParallaxLayer>[
      // Layer 5 – farthest background (sky / backdrop)
      ParallaxLayer(
        assetPath: 'assets/paralex_img/5.png',
        depthFactor: 1.8,
        scale: 1.25,
        blurSigma: 1.2,
        baseOffsetY: 40,
      ),
      // Layer 4
      ParallaxLayer(
        assetPath: 'assets/paralex_img/4.png',
        depthFactor: 1.3,
        scale: 1.20,
        blurSigma: 0.6,
        baseOffsetY: -20,

      ),
      // Layer 3 – middle ground
      ParallaxLayer(
        assetPath: 'assets/paralex_img/3.png',
        depthFactor: 0.8,
        scale: 1.16,
        baseOffsetY: -30,

      ),
         // Layer 2
      // Layer 2
      ParallaxLayer(
        assetPath: 'assets/paralex_img/2.png',
        depthFactor: 0.2,
        scale: 1.12,
        baseOffsetY: 60,

      ),
         ParallaxLayer(
        assetPath: 'assets/paralex_img/main.png',
        depthFactor: 0.1,
        scale: 0.7,
        baseOffsetY: 60,

      ),
      // Layer 1 – closest foreground (static, does not move)
      ParallaxLayer(
        assetPath: 'assets/paralex_img/1.png',
        depthFactor: 0.0,
        scale: 1.0,
      ),
    ];

    final parallaxScene = ParallaxDepthScene(
      layers: layers,
      maxOffset: 60,
      sensitivity: 0.12,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: kIsWeb ? _buildWebLayout(parallaxScene) : parallaxScene,
    );
  }

  /// On web, constrain the scene to a centered portrait frame.
  /// Adapts padding based on device type:
  ///   • Mobile  (width ≤ 500)  — full width, heavy top/bottom crop
  ///   • Tablet  (width ≤ 900)  — small side padding, moderate crop
  ///   • Desktop (width > 900)  — centered card with light crop
  Widget _buildWebLayout(Widget scene) {
    return LayoutBuilder(
      builder: (context, constraints) {

        return Center(
          child: AspectRatio(
            aspectRatio: 10 / 18,
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 95, horizontal: 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: scene,
              ),
            ),
          ),
        );
      },
    );
  }
}

