import 'package:flutter/material.dart';
import 'package:marionette_demo/core/theme.dart';
import 'package:marionette_demo/features/auth/fake_auth_service.dart';
import 'package:marionette_demo/features/auth/signup_screen.dart';
import 'package:marionette_demo/features/dashboard/dashboard_screen.dart';

/// Demo 01 — "Can you see my app?" · Demo 02 — "Can you use my app?"
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
  final _auth = const FakeAuthService();

  /// Flipped by `login_toggle_password_visibility`. A one-tap, one-observation
  /// change: ask the agent what the password field shows before and after
  /// tapping the eye, and it has to actually look twice.
  bool _obscure = true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  /// Signs in, then navigates. Deliberately asynchronous and deliberately
  /// failable: the agent has to act, wait, and look again to know what
  /// happened, which is the loop demo 02 is about.
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });

    final result = await _auth.signIn(
      email: _email.text,
      password: _password.text,
    );
    if (!mounted) return;

    setState(() => _busy = false);
    if (!result.isSuccess) {
      setState(() => _error = result.error);
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DashboardScreen(displayName: result.displayName!),
      ),
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
                  const SizedBox(height: 20),
                  Container(
                    key: const Key('login_demo_credentials'),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: DemoTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Demo account — ${FakeAuthService.demoEmail} / ${FakeAuthService.demoPassword}',
                      style: TextStyle(fontSize: 13, color: DemoTheme.muted),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  if (_error != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      key: const Key('login_error_banner'),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: DemoTheme.negative.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 18,
                            color: DemoTheme.negative,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _error!,
                              style: const TextStyle(
                                color: DemoTheme.negative,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  FilledButton(
                    key: const Key('login_submit_button'),
                    onPressed: _busy ? null : _submit,
                    child: _busy
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Log in'),
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
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const SignupScreen(),
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
