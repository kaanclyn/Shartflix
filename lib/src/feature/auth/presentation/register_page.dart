import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/social_buttons.dart';
import '../data/auth_repository.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/localization/strings.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameController.dispose();
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
          title: t.signUp,
          form: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: t.fullName,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      validator: (String? v) => (v == null || v.isEmpty)
                          ? t.nameRequired
                          : null,
                    ),
                    const SizedBox(height: 12),
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
              if (_formKey.currentState!.validate()) {
                final AuthRepository repo = AuthRepository();
                repo
                    .register(
                      name: _nameController.text.trim(),
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                    )
                    .then((_) {
                  if (!mounted) return;
                  context.go('/');
                }).catchError((Object e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${t.signupFailed}: $e')));
                });
              }
            },
            child: Text(t.signUp),
          ),
          belowButton: Column(
            children: <Widget>[
              TextButton(
                onPressed: () => context.go('/login'),
                child: Text(t.haveAccount),
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

