import 'package:flutter/material.dart';
import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/strings.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.form,
    required this.primaryButton,
    this.belowButton,
  });

  final String title;
  final Widget form;
  final Widget primaryButton;
  final Widget? belowButton;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLocaleController.instance,
      builder: (BuildContext context, Widget? _) {
        final S t = S.of(AppLocaleController.instance.locale);
        final Color primary = Theme.of(context).colorScheme.primary;
        final Color secondary = Theme.of(context).colorScheme.secondary;
        final Color footerColor = Colors.black.withOpacity(0.45);

        return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.3, -0.6),
                    radius: 1.1,
                    colors: <Color>[
                      Theme.of(context).colorScheme.primary.withOpacity(0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -60,
              left: -60,
              child: _circle(160, Theme.of(context).colorScheme.primary.withOpacity(0.10)),
            ),
            Positioned(
              bottom: 80,
              right: -40,
              child: _circle(120, Theme.of(context).colorScheme.secondary.withOpacity(0.10)),
            ),
            Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
                    child: Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  _FormCard(child: form),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 48,
                    child: primaryButton,
                  ),
                  if (belowButton != null) ...<Widget>[
                    const SizedBox(height: 12),
                    Center(child: belowButton!),
                  ],
                  const SizedBox(height: 40),
                  const SizedBox(height: 12),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(t.nodelabsRights, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(t.designer, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
          ],
        ),
      ),
        );
      },
    );
  }
}

Widget _circle(double size, Color color) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    ),
  );
}


class _FormCard extends StatelessWidget {
  const _FormCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

