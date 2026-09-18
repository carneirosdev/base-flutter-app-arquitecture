import 'package:app_template/features/home/presentation/home/widgets/home_placeholder.dart';
import 'package:app_template/shared/widgets/shimmer_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('mostra o skeleton enquanto carrega', (tester) async {
    await tester.pumpWidget(wrap(const HomePlaceholder(isLoading: true)));

    expect(find.byType(ShimmerSweep), findsOneWidget);
    expect(find.byType(SkeletonBox), findsWidgets);
  });

  testWidgets('mostra o conteúdo quando termina o carregamento',
      (tester) async {
    await tester.pumpWidget(wrap(const HomePlaceholder(isLoading: false)));

    expect(find.byType(ShimmerSweep), findsNothing);
    expect(find.byType(Text), findsOneWidget);
  });
}
