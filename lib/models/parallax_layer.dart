/// Represents a single layer in the 2.5D parallax scene.
///
/// Each layer has an [assetPath] pointing to the image asset,
/// and a [depthFactor] that controls how much it moves relative
/// to the input (gyroscope / cursor). Layers with a higher
/// [depthFactor] appear further in the background and move less,
/// while those with a lower factor move more and feel closer.
class ParallaxLayer {
  final String assetPath;

  /// How strongly this layer reacts to motion.
  /// Positive values → moves *with* the tilt/cursor.
  /// Negative values → moves *against* it (foreground pop-out).
  /// 0 → completely static.
  final double depthFactor;

  /// Optional fixed scale for the layer image (1.0 = 100 %).
  final double scale;

  /// Whether to apply a slight blur to reinforce depth-of-field.
  final double blurSigma;

  /// A fixed vertical offset (in logical pixels) applied to this layer.
  /// Positive values push the layer **down**, negative values push it **up**.
  final double baseOffsetY;

  const ParallaxLayer({
    required this.assetPath,
    required this.depthFactor,
    this.scale = 1.15,
    this.blurSigma = 0.0,
    this.baseOffsetY = 0.0,
  });
}
