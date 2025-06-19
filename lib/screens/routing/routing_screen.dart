import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Needed for CustomPainter's Material colors

class RoutingScreen extends StatefulWidget {
  final String destinationId;
  const RoutingScreen({super.key, required this.destinationId});

  @override
  State<RoutingScreen> createState() => _RoutingScreenState();
}

class _RoutingScreenState extends State<RoutingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: Stack(
              children: [
                Image.asset('assets/images/map_placeholder.jpg'),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) => CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: RoutePainter(progress: _animation.value),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 15,
                  child: _buildFloatingButton(
                    icon: CupertinoIcons.back,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 2))]),
      child: CupertinoButton(padding: EdgeInsets.zero, onPressed: onPressed, child: CircleAvatar(radius: 22, backgroundColor: Colors.white, child: Icon(icon, color: Colors.black))),
    );
  }
}

class RoutePainter extends CustomPainter {
  final double progress;
  RoutePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = CupertinoColors.systemGreen..strokeWidth = 6..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final path = Path()..moveTo(size.width * 0.45, size.height * 0.8)..lineTo(size.width * 0.48, size.height * 0.5)..lineTo(size.width * 0.55, size.height * 0.4);
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      final extractPath = metric.extractPath(0.0, metric.length * progress);
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant RoutePainter oldDelegate) => oldDelegate.progress != progress;
}