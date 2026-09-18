import 'package:flutter/material.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;

class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: kit.AppColors.neutralGray,
          borderRadius: BorderRadius.circular(kit.AppRadius.radius4),
        ),
      ),
    );
  }
}
