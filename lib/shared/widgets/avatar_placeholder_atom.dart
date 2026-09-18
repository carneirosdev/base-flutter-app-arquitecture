import 'package:flutter/material.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;

class AvatarPlaceholderAtom extends StatelessWidget {
  const AvatarPlaceholderAtom({super.key, this.size = 52});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: kit.AppColors.neutralGray,
      child: Icon(Icons.person, size: size * 0.55, color: kit.AppColors.white),
    );
  }
}
