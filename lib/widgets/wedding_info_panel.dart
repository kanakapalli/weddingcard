import 'dart:math';
import 'package:flutter/material.dart';

/// Right-side panel showing all wedding details, timeline, and RSVP form.
class WeddingInfoPanel extends StatefulWidget {
  const WeddingInfoPanel({super.key});

  @override
  State<WeddingInfoPanel> createState() => _WeddingInfoPanelState();
}

class _WeddingInfoPanelState extends State<WeddingInfoPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideIn;

  // RSVP form
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _guestsController = TextEditingController(text: '1');
  final _messageController = TextEditingController();
  String _attendance = 'Joyfully Accept';
  bool _rsvpSubmitted = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeIn = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _slideIn = Tween<Offset>(
      begin: const Offset(0.15, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _guestsController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideIn,
      child: FadeTransition(
        opacity: _fadeIn,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0D0906),
                Color(0xFF1A1208),
                Color(0xFF0D0906),
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTopOrnament(),
                const SizedBox(height: 32),
                _buildHeader(),
                const SizedBox(height: 12),
                _buildDivider(),
                const SizedBox(height: 32),
                _buildCoupleNames(),
                const SizedBox(height: 28),
                _buildDivider(),
                const SizedBox(height: 32),
                _buildDateTimeSection(),
                const SizedBox(height: 32),
                _buildDivider(),
                const SizedBox(height: 32),
                _buildVenueSection(),
                const SizedBox(height: 32),
                _buildDivider(),
                const SizedBox(height: 32),
                _buildTimelineSection(),
                const SizedBox(height: 32),
                _buildDivider(),
                const SizedBox(height: 32),
                _buildDressCodeSection(),
                const SizedBox(height: 32),
                _buildDivider(),
                const SizedBox(height: 40),
                _buildRSVPSection(),
                const SizedBox(height: 40),
                _buildFooter(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopOrnament() {
    return SizedBox(
      height: 40,
      width: 160,
      child: CustomPaint(
        painter: _FloralOrnamentPainter(color: const Color(0xFFD4A843)),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'WEDDING INVITATION',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            letterSpacing: 6,
            color: const Color(0xFFD4A843).withValues(alpha: 0.7),
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Together with their families',
          style: TextStyle(
            fontSize: 15,
            fontStyle: FontStyle.italic,
            color: Color(0xFFBBA67A),
            fontFamily: 'serif',
          ),
        ),
      ],
    );
  }

  Widget _buildCoupleNames() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [
                Color(0xFFD4A843),
                Color(0xFFFFF5CC),
                Color(0xFFD4A843),
              ],
            ).createShader(bounds);
          },
          child: const Text(
            'Rajesh',
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              fontFamily: 'serif',
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '&',
          style: TextStyle(
            fontSize: 32,
            fontStyle: FontStyle.italic,
            color: const Color(0xFFD4A843).withValues(alpha: 0.8),
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 4),
        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [
                Color(0xFFD4A843),
                Color(0xFFFFF5CC),
                Color(0xFFD4A843),
              ],
            ).createShader(bounds);
          },
          child: const Text(
            'Priya',
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              fontFamily: 'serif',
              height: 1.1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    return Column(
      children: [
        _goldIcon(Icons.calendar_today_outlined, size: 28),
        const SizedBox(height: 12),
        const Text(
          'SAVE THE DATE',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 5,
            color: Color(0xFFD4A843),
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _dateBlock('SAT', '14'),
            _dateSeparator(),
            _dateBlock('MAR', '2026'),
            _dateSeparator(),
            _dateBlock('AT', '10:30 AM'),
          ],
        ),
      ],
    );
  }

  Widget _dateBlock(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 3,
            color: const Color(0xFFD4A843).withValues(alpha: 0.6),
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w300,
            color: Color(0xFFFFF5CC),
            fontFamily: 'serif',
          ),
        ),
      ],
    );
  }

  Widget _dateSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: 1,
        height: 36,
        color: const Color(0xFFD4A843).withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildVenueSection() {
    return Column(
      children: [
        _goldIcon(Icons.location_on_outlined, size: 28),
        const SizedBox(height: 12),
        const Text(
          'VENUE',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 5,
            color: Color(0xFFD4A843),
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'The Royal Grand Palace',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w300,
            color: Color(0xFFFFF5CC),
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Lotus Banquet Hall\n123 Heritage Road, Jubilee Hills\nHyderabad, Telangana 500033',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.7,
            color: const Color(0xFFBBA67A).withValues(alpha: 0.8),
            fontFamily: 'serif',
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineSection() {
    return Column(
      children: [
        _goldIcon(Icons.schedule_outlined, size: 28),
        const SizedBox(height: 12),
        const Text(
          'CEREMONY TIMELINE',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 5,
            color: Color(0xFFD4A843),
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 24),
        _timelineItem('10:30 AM', 'Guest Arrival & Welcome', Icons.people_outline),
        _timelineItem('11:00 AM', 'Haldi Ceremony', Icons.spa_outlined),
        _timelineItem('12:30 PM', 'Lunch Banquet', Icons.restaurant_outlined),
        _timelineItem('03:00 PM', 'Mehendi Ceremony', Icons.brush_outlined),
        _timelineItem('06:00 PM', 'Wedding Ceremony', Icons.favorite_outline),
        _timelineItem('08:00 PM', 'Reception & Dinner', Icons.celebration_outlined),
        _timelineItem('10:00 PM', 'Dance & Celebration', Icons.music_note_outlined),
      ],
    );
  }

  Widget _timelineItem(String time, String event, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              time,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFFD4A843),
                fontFamily: 'serif',
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFD4A843).withValues(alpha: 0.4),
              ),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFFD4A843)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              event,
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFFFFF5CC).withValues(alpha: 0.9),
                fontFamily: 'serif',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDressCodeSection() {
    return Column(
      children: [
        _goldIcon(Icons.checkroom_outlined, size: 28),
        const SizedBox(height: 12),
        const Text(
          'DRESS CODE',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 5,
            color: Color(0xFFD4A843),
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Traditional / Ethnic Wear',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: Color(0xFFFFF5CC),
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We request our guests to grace the occasion\nin their finest traditional attire.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontStyle: FontStyle.italic,
            height: 1.6,
            color: const Color(0xFFBBA67A).withValues(alpha: 0.7),
            fontFamily: 'serif',
          ),
        ),
      ],
    );
  }

  Widget _buildRSVPSection() {
    return Column(
      children: [
        _goldIcon(Icons.mail_outline, size: 28),
        const SizedBox(height: 12),
        const Text(
          'RSVP',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 5,
            color: Color(0xFFD4A843),
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Kindly respond by March 1, 2026',
          style: TextStyle(
            fontSize: 13,
            fontStyle: FontStyle.italic,
            color: const Color(0xFFBBA67A).withValues(alpha: 0.7),
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 24),

        if (_rsvpSubmitted) ...[
          _buildRSVPSuccess(),
        ] else ...[
          _buildRSVPForm(),
        ],
      ],
    );
  }

  Widget _buildRSVPSuccess() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD4A843).withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Color(0xFFD4A843),
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            'Thank You!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: Color(0xFFFFF5CC),
              fontFamily: 'serif',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your response has been recorded.\nWe look forward to celebrating with you!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: const Color(0xFFBBA67A).withValues(alpha: 0.8),
              fontFamily: 'serif',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRSVPForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Attendance dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFD4A843).withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _attendance,
                dropdownColor: const Color(0xFF1A1208),
                isExpanded: true,
                style: const TextStyle(
                  color: Color(0xFFFFF5CC),
                  fontFamily: 'serif',
                  fontSize: 14,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFFD4A843),
                ),
                items: ['Joyfully Accept', 'Respectfully Decline']
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (v) => setState(() => _attendance = v!),
              ),
            ),
          ),
          const SizedBox(height: 16),

          _buildTextField(_nameController, 'Full Name *', Icons.person_outline),
          const SizedBox(height: 16),

          _buildTextField(_emailController, 'Email Address *', Icons.email_outlined,
              type: TextInputType.emailAddress),
          const SizedBox(height: 16),

          _buildTextField(_phoneController, 'Phone Number', Icons.phone_outlined,
              type: TextInputType.phone, required_: false),
          const SizedBox(height: 16),

          _buildTextField(
              _guestsController, 'Number of Guests', Icons.group_outlined,
              type: TextInputType.number, required_: false),
          const SizedBox(height: 16),

          _buildTextField(
              _messageController, 'Message for the Couple', Icons.message_outlined,
              maxLines: 3, required_: false),
          const SizedBox(height: 28),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _submitRSVP,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4A843),
                foregroundColor: const Color(0xFF0A0A0A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'SEND RSVP',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 4,
                  fontFamily: 'serif',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType type = TextInputType.text,
    int maxLines = 1,
    bool required_ = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      maxLines: maxLines,
      style: const TextStyle(
        color: Color(0xFFFFF5CC),
        fontFamily: 'serif',
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: const Color(0xFFBBA67A).withValues(alpha: 0.6),
          fontFamily: 'serif',
          fontSize: 13,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFFD4A843), size: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: const Color(0xFFD4A843).withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD4A843)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
      validator: required_
          ? (v) => (v == null || v.trim().isEmpty) ? 'Please enter $label' : null
          : null,
    );
  }

  void _submitRSVP() {
    if (_formKey.currentState!.validate()) {
      setState(() => _rsvpSubmitted = true);
    }
  }

  Widget _buildFooter() {
    return Column(
      children: [
        _buildTopOrnament(),
        const SizedBox(height: 20),
        Text(
          'With love and blessings',
          style: TextStyle(
            fontSize: 15,
            fontStyle: FontStyle.italic,
            color: const Color(0xFFBBA67A).withValues(alpha: 0.7),
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 8),
        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [
                Color(0xFFD4A843),
                Color(0xFFFFF5CC),
                Color(0xFFD4A843),
              ],
            ).createShader(bounds);
          },
          child: const Text(
            'The Sharma & Patel Family',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontFamily: 'serif',
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _contactInfo(Icons.phone_outlined, '+91 98765 43210'),
            const SizedBox(width: 24),
            _contactInfo(Icons.email_outlined, 'wedding@family.com'),
          ],
        ),
      ],
    );
  }

  Widget _contactInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFFD4A843)),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: const Color(0xFFBBA67A).withValues(alpha: 0.7),
            fontFamily: 'serif',
          ),
        ),
      ],
    );
  }

  Widget _goldIcon(IconData icon, {double size = 24}) {
    return Container(
      width: size + 20,
      height: size + 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFD4A843).withValues(alpha: 0.3),
        ),
      ),
      child: Icon(icon, size: size, color: const Color(0xFFD4A843)),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  const Color(0xFFD4A843).withValues(alpha: 0.4),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFD4A843),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFD4A843).withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FloralOrnamentPainter extends CustomPainter {
  final Color color;

  _FloralOrnamentPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final midY = size.height / 2;
    final midX = size.width / 2;

    // Center flower
    for (int i = 0; i < 4; i++) {
      final angle = (i * pi / 2);
      final petalPath = Path()
        ..moveTo(midX, midY)
        ..quadraticBezierTo(
          midX + 8 * cos(angle - 0.4),
          midY + 8 * sin(angle - 0.4),
          midX + 5 * cos(angle),
          midY + 5 * sin(angle),
        );
      canvas.drawPath(petalPath, paint);
    }

    // Decorative lines
    canvas.drawLine(Offset(midX - 12, midY), Offset(midX - 65, midY), paint);
    canvas.drawLine(Offset(midX + 12, midY), Offset(midX + 65, midY), paint);

    // End curls
    final leftCurl = Path()
      ..moveTo(midX - 65, midY)
      ..quadraticBezierTo(midX - 78, midY - 10, midX - 72, midY + 4);
    canvas.drawPath(leftCurl, paint);

    final rightCurl = Path()
      ..moveTo(midX + 65, midY)
      ..quadraticBezierTo(midX + 78, midY - 10, midX + 72, midY + 4);
    canvas.drawPath(rightCurl, paint);

    // Small dots
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(midX - 30, midY), 1.5, dotPaint);
    canvas.drawCircle(Offset(midX + 30, midY), 1.5, dotPaint);
    canvas.drawCircle(Offset(midX - 50, midY), 1.5, dotPaint);
    canvas.drawCircle(Offset(midX + 50, midY), 1.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
