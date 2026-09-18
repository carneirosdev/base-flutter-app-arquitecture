import 'package:flutter/material.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;

/// Caixa cinzenta usada como bloco base de um placeholder animado.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = kit.AppRadius.radius4,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Aplica um varrimento de brilho (estilo YouTube) sobre o [child],
/// reutilizado por todos os placeholders de carregamento do app.
class ShimmerSweep extends StatefulWidget {
  const ShimmerSweep({super.key, required this.child});

  final Widget child;

  @override
  State<ShimmerSweep> createState() => _ShimmerSweepState();
}

class _ShimmerSweepState extends State<ShimmerSweep>
    with SingleTickerProviderStateMixin {
  static const Duration _sweepDuration = Duration(milliseconds: 1400);
  static const Color _base = Color(0xFFE8E8E8);
  static const Color _highlight = Color(0xFFF5F5F5);

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _sweepDuration)
      ..repeat();
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
      builder: (context, child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: _buildShader,
        child: child,
      ),
      child: widget.child,
    );
  }

  Shader _buildShader(Rect bounds) {
    final slide = _controller.value * 2 - 1;
    return LinearGradient(
      begin: Alignment(slide - 1, 0),
      end: Alignment(slide + 1, 0),
      colors: const [_base, _highlight, _base],
      stops: const [0.35, 0.5, 0.65],
    ).createShader(bounds);
  }
}
