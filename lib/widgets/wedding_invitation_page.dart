import 'package:flutter/material.dart';

import 'wedding_info_panel.dart';

/// The main wedding invitation page layout.
///
/// - **Left side**: The parallax wedding card (`WeddingCardView` from main.dart)
/// - **Right side**: Wedding details, timeline, RSVP
///
/// On smaller screens (mobile), it stacks vertically.
class WeddingInvitationPage extends StatefulWidget {
  /// The wedding card widget to place on the left side.
  final Widget weddingCard;

  const WeddingInvitationPage({
    super.key,
    required this.weddingCard,
  });

  @override
  State<WeddingInvitationPage> createState() => _WeddingInvitationPageState();
}

class _WeddingInvitationPageState extends State<WeddingInvitationPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _revealController;
  late final Animation<double> _cardReveal;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _cardReveal = CurvedAnimation(
      parent: _revealController,
      curve: Curves.easeOutCubic,
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _revealController.forward();
    });
  }

  @override
  void dispose() {
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;

          if (isWide) {
            return _buildWideLayout(constraints);
          } else {
            return _buildNarrowLayout(constraints);
          }
        },
      ),
    );
  }

  /// Wide layout: Card on left, info on right
  Widget _buildWideLayout(BoxConstraints constraints) {
    return Row(
      children: [
        // Left side – Wedding Card
        FadeTransition(
          opacity: _cardReveal,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-0.1, 0),
              end: Offset.zero,
            ).animate(_cardReveal),
            child: SizedBox(
              width: constraints.maxWidth * 0.42,
              child: _buildCardSection(),
            ),
          ),
        ),

        // Gold divider line
        Container(
          width: 1,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                const Color(0xFFD4A843).withValues(alpha: 0.4),
                const Color(0xFFD4A843).withValues(alpha: 0.6),
                const Color(0xFFD4A843).withValues(alpha: 0.4),
                Colors.transparent,
              ],
            ),
          ),
        ),

        // Right side – Wedding info & RSVP
        Expanded(
          child: WeddingInfoPanel(),
        ),
      ],
    );
  }

  /// Narrow layout: Stacked vertically (mobile web)
  Widget _buildNarrowLayout(BoxConstraints constraints) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Wedding card at top
          FadeTransition(
            opacity: _cardReveal,
            child: SizedBox(
              height: constraints.maxHeight * 0.85,
              child: _buildCardSection(),
            ),
          ),

          // Decorative transition
          _buildSectionTransition(),

          // Wedding info & RSVP below
          const WeddingInfoPanel(),
        ],
      ),
    );
  }

  Widget _buildCardSection() {
    return Container(
      color: Colors.black,
      child: Center(
        child: widget.weddingCard,
      ),
    );
  }

  Widget _buildSectionTransition() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black,
            Color(0xFF0D0906),
          ],
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _gradientLine(toRight: false),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFFD4A843),
                size: 24,
              ),
            ),
            _gradientLine(toRight: true),
          ],
        ),
      ),
    );
  }

  Widget _gradientLine({required bool toRight}) {
    return Container(
      width: 60,
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: toRight
              ? [
                  const Color(0xFFD4A843).withValues(alpha: 0.5),
                  Colors.transparent,
                ]
              : [
                  Colors.transparent,
                  const Color(0xFFD4A843).withValues(alpha: 0.5),
                ],
        ),
      ),
    );
  }
}
