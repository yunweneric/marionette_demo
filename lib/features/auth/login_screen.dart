import 'package:flutter/material.dart';
import 'package:marionette_demo/core/theme.dart';

/// Demo 01 — "Can you see my app?"
///
/// Every control carries a `Key`, because that is what the agent gets back
/// from `get_interactive_elements` and what it passes to `tap` and
/// `enter_text`. A screen without keys is still drivable by visible text, but
/// keys survive copy changes and translation — and this app is bilingual
/// French/English in the audience's head even when the strings are not.
///
/// Naming convention for the keys, worth keeping if you extend this app:
/// `<screen>_<thing>_<kind>` — `login_email_field`, `login_submit_button`.
/// The agent reads them back as a flat list, so the prefix is what tells it
/// which screen it is standing on.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  /// Flipped by `login_toggle_password_visibility`. A one-tap, one-observation
  /// change: ask the agent what the password field shows before and after
  /// tapping the eye, and it has to actually look twice.
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  /// Not wired to anything yet — demo 02 is where this screen starts going
  /// somewhere.
  ///
  /// It does two things the agent can see: a `debugPrint`, which reaches
  /// `get_logs` through the collector in `main.dart`, and a SnackBar, which
  /// appears in the element tree for a few seconds and then does not. That
  /// disappearing act is a good first lesson on stage: what the agent sees is
  /// a moment, not a fact.
  void _submit() {
    debugPrint(
      '[login] submit email=${_email.text} password=${'*' * _password.text.length}',
    );
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(content: Text('Sign-in is not wired up on this branch')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Dash's employer, and a widget with no key on purpose:
                  // decoration the agent has no reason to touch.
                  const FlutterLogo(size: 48),
                  const SizedBox(height: 28),
                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: DemoTheme.ink,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to your Togeva account.',
                    style: TextStyle(fontSize: 15, color: DemoTheme.muted),
                  ),
                  const SizedBox(height: 28),
                  const _FieldLabel('Email'),
                  const SizedBox(height: 8),
                  TextField(
                    key: const Key('login_email_field'),
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'you@example.com',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const _FieldLabel('Password'),
                  const SizedBox(height: 8),
                  TextField(
                    key: const Key('login_password_field'),
                    controller: _password,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      hintText: 'Your password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        key: const Key('login_toggle_password_visibility'),
                        tooltip: _obscure ? 'Show password' : 'Hide password',
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      key: const Key('login_forgot_password_button'),
                      onPressed: () {
                        debugPrint('[login] forgot password tapped');
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text('Reset link sent to your inbox'),
                            ),
                          );
                      },
                      child: const Text('Forgot password'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    key: const Key('login_submit_button'),
                    onPressed: _submit,
                    child: const Text('Log in'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'New here?',
                        style: TextStyle(color: DemoTheme.muted),
                      ),
                      TextButton(
                        key: const Key('login_signup_button'),
                        onPressed: () {
                          debugPrint('[login] sign up tapped');
                          ScaffoldMessenger.of(context)
                            ..clearSnackBars()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text('Sign-up arrives in demo 04'),
                              ),
                            );
                        },
                        child: const Text('Sign up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: DemoTheme.muted,
      ),
    );
  }
}
