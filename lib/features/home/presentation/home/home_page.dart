import 'package:app_template/features/home/presentation/home/home_controller.dart';
import 'package:app_template/features/home/presentation/home/widgets/home_placeholder.dart';
import 'package:app_template/injector/dependency_injector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;

/// Ecrã inicial da aplicação.
///
/// Serve de ponto de partida do template: compõe widgets e não contém
/// lógica de negócio. Substitui [HomePlaceholder] pelo conteúdo real.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _controller = injector.get<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kit.AppColors.background,
      appBar: AppBar(
        title: const Text('Início'),
        actions: [
          IconButton(
            onPressed: _controller.logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Terminar sessão',
          ),
        ],
      ),
      body: Obx(
        () => HomePlaceholder(isLoading: _controller.isLoading.value),
      ),
    );
  }
}
