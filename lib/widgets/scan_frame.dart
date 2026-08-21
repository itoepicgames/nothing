import 'package:flutter/material.dart';

class ScanFrame extends StatefulWidget {
  const ScanFrame({super.key});

  @override
  State<ScanFrame> createState() => _ScanFrameState();
}

class _ScanFrameState extends State<ScanFrame> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1900),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _FramePainter(
            progress: _controller.value,
            accent: scheme.primary,
          ),
          child: child,
        );
      },
      child: const SizedBox.expand(),
    );
  }
}

class _FramePainter extends CustomPainter {
  _FramePainter({required this.progress, required this.accent});
  final double progress;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * .48),
        width: size.width * .82,
        height: size.width * .82,
      ),
      const Radius.circular(28),
    );
    final dim = Paint()..color = Colors.black.withValues(alpha: .48);
    final path = Path()
      ..addRect(Offset.zero & size)
      ..addRRect(rect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, dim);

    final border = Paint()
      ..color = Colors.white.withValues(alpha: .88)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(rect, border);

    final left = rect.left;
    final right = rect.right;
    final top = rect.top;
    final bottom = rect.bottom;
    final corner = 26.0;
    final accentPaint = Paint()
      ..color = accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final p = Path()
      ..moveTo(left, top + corner)
      ..lineTo(left, top)
      ..lineTo(left + corner, top)
      ..moveTo(right - corner, top)
      ..lineTo(right, top)
      ..lineTo(right, top + corner)
      ..moveTo(left, bottom - corner)
      ..lineTo(left, bottom)
      ..lineTo(left + corner, bottom)
      ..moveTo(right - corner, bottom)
      ..lineTo(right, bottom)
      ..lineTo(right, bottom - corner);
    canvas.drawPath(p, accentPaint);

    final y = top + 12 + (rect.height - 24) * progress;
    final line = Paint()
      ..shader = LinearGradient(
        colors: [Colors.transparent, accent, Colors.transparent],
      ).createShader(Rect.fromLTWH(left + 18, y, rect.width - 36, 3));
    canvas.drawRect(Rect.fromLTWH(left + 18, y, rect.width - 36, 3), line);
  }

  @override
  bool shouldRepaint(covariant _FramePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.accent != accent;
}
