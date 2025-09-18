import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/social_buttons.dart';
import '../data/auth_repository.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/localization/strings.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLocaleController.instance,
      builder: (BuildContext context, Widget? _) {
        final S t = S.of(AppLocaleController.instance.locale);
        return AuthScaffold(
          title: t.signIn,
          form: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: t.email,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      validator: (String? v) => (v == null || v.isEmpty)
                          ? t.emailRequired
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        hintText: t.password,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (String? v) => (v == null || v.length < 6)
                          ? t.passwordMinLength
                          : null,
                    ),
              ],
            ),
          ),
          primaryButton: FilledButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (_formKey.currentState!.validate()) {
                final AuthRepository repo = AuthRepository();
                repo.login(email: _emailController.text.trim(), password: _passwordController.text).then((_) async {
                  if (!mounted) return;
                  FocusScope.of(context).unfocus();
                  int left = 3;
                  Timer? timer;
                  await showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext dialogContext) {
                      return StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) setState) {
                          timer ??= Timer.periodic(const Duration(seconds: 1), (Timer t) {
                            if (left <= 1) {
                              t.cancel();
                              if (Navigator.of(dialogContext).canPop()) {
                                Navigator.of(dialogContext).pop();
                              }
                              if (mounted) context.go('/');
                            } else {
                              setState(() => left -= 1);
                            }
                          });
                          return WillPopScope(
                            onWillPop: () async => false,
                            child: AlertDialog(
                              backgroundColor: Colors.white,
                              content: Row(
                                children: <Widget>[
                                  const Icon(Icons.check_circle, color: Colors.green, size: 28),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(t.loginSuccess, style: const TextStyle(fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 4),
                                        Text('${t.secureRedirect} · ${t.redirectingIn}: ${left}${t.secondsSuffix}',
                                            style: const TextStyle(color: Colors.black54)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }).catchError((Object e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${t.loginFailed}: $e')));
                });
              }
            },
            child: Text(t.signIn),
          ),
          belowButton: Column(
            children: <Widget>[
              TextButton(
                onPressed: () => context.go('/register'),
                child: Text(t.noAccount),
              ),
              const SizedBox(height: 12),
              const SocialButtons(),
            ],
          ),
        );
      },
    );
  }
}

