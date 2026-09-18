import 'package:flutter/material.dart';

/// Logótipo do ecrã de boas-vindas.
///
/// Coloca o logótipo do novo projeto em `assets/img_logo.png`.
class WelcomeLogo extends StatelessWidget {
  const WelcomeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/img_logo.png',
        width: 179,
        height: 63,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const SizedBox(width: 179, height: 63),
      ),
    );
  }
}
