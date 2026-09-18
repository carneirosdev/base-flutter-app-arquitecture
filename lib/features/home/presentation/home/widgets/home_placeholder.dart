import 'package:app_template/shared/widgets/shimmer_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;

/// Conteúdo de exemplo do ecrã inicial.
///
/// Demonstra a regra de carregamento do projeto: enquanto [isLoading] é
/// verdadeiro mostra um skeleton com a forma do conteúdo real, nunca um
/// `CircularProgressIndicator`.
class HomePlaceholder extends StatelessWidget {
  const HomePlaceholder({super.key, required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const _HomeSkeleton();
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(kit.AppSpacing.lg),
        child: Text(
          'Substitui este ecrã pelo conteúdo do teu projeto.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: kit.AppTypography.MDTextFontSize,
            color: kit.AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(kit.AppSpacing.lg),
      child: ShimmerSweep(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(
              width: 180,
              height: 24,
              radius: kit.AppRadius.radius8,
            ),
            SizedBox(height: kit.AppSpacing.md),
            SkeletonBox(
              width: double.infinity,
              height: 96,
              radius: kit.AppRadius.radius12,
            ),
            SizedBox(height: kit.AppSpacing.sm),
            SkeletonBox(
              width: double.infinity,
              height: 96,
              radius: kit.AppRadius.radius12,
            ),
          ],
        ),
      ),
    );
  }
}
