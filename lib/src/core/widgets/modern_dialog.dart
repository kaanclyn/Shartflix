import 'dart:ui';
import 'package:flutter/material.dart';

Future<void> showModernInfoDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final Color primary = Theme.of(context).colorScheme.primary;

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withOpacity(0.25),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (BuildContext _, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (BuildContext _, Animation<double> anim, __, ___) {
      final double t = Curves.easeOut.transform(anim.value);
      return Opacity(
        opacity: t,
        child: Transform.scale(
          scale: 0.96 + 0.04 * t,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    constraints: const BoxConstraints(maxWidth: 340),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.info_outline, color: primary, size: 20),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              behavior: HitTestBehavior.opaque,
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(Icons.close_rounded, size: 20),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}


Future<bool> showModernConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = 'Continue',
  String cancelText = 'Cancel',
}) async {
  final Color primary = Theme.of(context).colorScheme.primary;
  bool? result;
  await showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withOpacity(0.35),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (BuildContext _, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (BuildContext _, Animation<double> anim, __, ___) {
      final double t = Curves.easeOut.transform(anim.value);
      return Opacity(
        opacity: t,
        child: Transform.scale(
          scale: 0.96 + 0.04 * t,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.82,
                    constraints: const BoxConstraints(maxWidth: 380),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.help_outline, color: primary, size: 20),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              behavior: HitTestBehavior.opaque,
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(Icons.close_rounded, size: 20),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9)),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  result = false;
                                  Navigator.of(context).pop();
                                },
                                child: Text(cancelText),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  result = true;
                                  Navigator.of(context).pop();
                                },
                                child: Text(confirmText),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
  return result ?? false;
}


