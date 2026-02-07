import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'models/parallax_layer.dart';
import 'widgets/parallax_depth_scene.dart';
import 'widgets/royal_splash_screen.dart';
import 'widgets/wedding_invitation_page.dart';

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
/// On **web**: Shows a royal splash screen → then the full
/// wedding invitation layout (card on left, details + RSVP on right).
///
/// On **mobile**: Shows the parallax scene driven by gyroscope.
class ParallaxHomePage extends StatefulWidget {
  const ParallaxHomePage({super.key});

  @override
  State<ParallaxHomePage> createState() => _ParallaxHomePageState();
}

class _ParallaxHomePageState extends State<ParallaxHomePage> {
  bool _splashComplete = false;

  @override
  Widget build(BuildContext context) {
    // Define layers back-to-front (5 is farthest background, 1 is closest foreground).
    const layers = <ParallaxLayer>[
      ParallaxLayer(
        assetPath: 'assets/paralex_img/5.png',
        depthFactor: 1.8,
        scale: 1.25,
        blurSigma: 1.2,
        baseOffsetY: 40,
      ),
      ParallaxLayer(
        assetPath: 'assets/paralex_img/4.png',
        depthFactor: 1.3,
        scale: 1.20,
        blurSigma: 0.6,
        baseOffsetY: -20,
      ),
      ParallaxLayer(
        assetPath: 'assets/paralex_img/3.png',
        depthFactor: 0.8,
        scale: 1.16,
        baseOffsetY: -30,
      ),
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

    // Mobile: just show the parallax scene
    if (!kIsWeb) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: parallaxScene,
      );
    }

    // Web: splash → invitation page
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _splashComplete
          ? WeddingInvitationPage(
              key: const ValueKey('invitation'),
              weddingCard: WeddingCardView(),
            )
          : RoyalSplashScreen(
              key: const ValueKey('splash'),
              onComplete: () {
                setState(() => _splashComplete = true);
              },
            ),
    );
  }
}

class WeddingCardView extends StatefulWidget {
  const WeddingCardView({
    super.key,
  });

  @override
  State<WeddingCardView> createState() => _WeddingCardViewState();
}

class _WeddingCardViewState extends State<WeddingCardView> {
  
    final parallaxScene = ParallaxDepthScene(
      layers:  <ParallaxLayer>[
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
    ],
      maxOffset: 60,
      sensitivity: 0.12,
    );

  @override
  Widget build(BuildContext context) {

    return AspectRatio(
      aspectRatio: 10 / 18,
      child: Container(
        color: Colors.black,
        padding: EdgeInsets.symmetric(vertical: 95, horizontal: 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: parallaxScene,
        ),
      ),
    );
  }
}

