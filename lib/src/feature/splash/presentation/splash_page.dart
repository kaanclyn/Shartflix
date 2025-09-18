import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/localization/strings.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    

    _logoController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _logoScale = CurvedAnimation(parent: _logoController, curve: Curves.elasticOut);
    _logoFade = CurvedAnimation(parent: _logoController, curve: Curves.easeIn);
    
    _textController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _textFade = CurvedAnimation(parent: _textController, curve: Curves.easeIn);
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _textController, curve: Curves.easeOutBack));
    
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _textController.forward();
    });
    
    _timer = Timer(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      _navigateToLogin();
    });
  }
  
  Future<void> _navigateToLogin() async {
    await _logoController.reverse();
    await _textController.reverse();
    if (!mounted) return;
    context.go('/login');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLocaleController.instance,
      builder: (BuildContext context, Widget? _) {
        final S t = S.of(AppLocaleController.instance.locale);
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Stack(
            children: <Widget>[
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.2, -0.4),
                      radius: 1.0,
                      colors: <Color>[
                        Theme.of(context).colorScheme.primary.withOpacity(0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: <Color>[
                                Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                Colors.white.withOpacity(0.08),
                              ],
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24, width: 2),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Image(
                              image: AssetImage('assets/icon/Shart (1) (1).png'),
                              width: 56,
                              height: 56,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SlideTransition(
                      position: _textSlide,
                      child: FadeTransition(
                        opacity: _textFade,
                        child: Column(
                          children: <Widget>[
                            Text(
                              t.appTitle,
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Cinematic streaming experience',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


