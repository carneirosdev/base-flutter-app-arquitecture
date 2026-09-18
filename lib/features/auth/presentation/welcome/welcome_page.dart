import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_template/features/auth/presentation/login/login_sheet.dart';
import 'package:app_template/features/auth/presentation/welcome/welcome_controller.dart';
import 'package:app_template/features/auth/presentation/welcome/widgets/logo.dart';
import 'package:app_template/features/auth/presentation/welcome/widgets/phone_button.dart';
import 'package:app_template/features/auth/presentation/welcome/widgets/tagline.dart';
import 'package:app_template/injector/dependency_injector.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _logoOffset;
  late final Animation<double> _taglineOpacity;
  late final Animation<double> _buttonOpacity;
  late final Animation<Offset> _buttonOffset;

  late final WelcomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = injector.get<WelcomeController>();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _logoOpacity = _buildFade(0.0, 0.35);
    _logoOffset = _buildSlide(0.0, 0.35, const Offset(0, -0.4));
    _taglineOpacity = _buildFade(0.45, 0.78);
    _buttonOpacity = _buildFade(0.65, 1.0);
    _buttonOffset = _buildSlide(0.65, 1.0, const Offset(0, 0.5));

    _animationController.forward();
  }

  Animation<double> _buildFade(double start, double end) =>
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );

  Animation<Offset> _buildSlide(double start, double end, Offset from) =>
      Tween<Offset>(begin: from, end: Offset.zero).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onEnterPressed() async {
    final navigated = await _controller.handleEnterButton();
    if (!navigated && mounted) {
      _showLoginSheet();
    }
  }

  void _showLoginSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: const LoginSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kit.AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Expanded(
              flex: 8,
              child: Column(
                children: [
                  FadeTransition(
                    opacity: _logoOpacity,
                    child: SlideTransition(
                      position: _logoOffset,
                      child: const WelcomeLogo(),
                    ),
                  ),
                  const Spacer(),
                  FadeTransition(
                    opacity: _taglineOpacity,
                    child: const WelcomeTagline(),
                  ),
                ],
              ),
            ),
            const Spacer(),
            FadeTransition(
              opacity: _buttonOpacity,
              child: SlideTransition(
                position: _buttonOffset,
                child: Obx(
                  () => _controller.isLoading.value
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: CircularProgressIndicator(),
                        )
                      : PhoneButton(onPressed: () => _onEnterPressed()),
                ),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
