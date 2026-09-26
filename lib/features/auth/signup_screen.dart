import 'package:flutter/material.dart';
import 'package:marionette_demo/core/theme.dart';
import 'package:marionette_demo/features/dashboard/dashboard_screen.dart';

/// The finished state of demo 04, kept on `main` as the reference the branch
/// is diffed against on stage.
///
/// Validation is per field and shown in place, and it only starts nagging
/// after the first submit — `onUserInteraction` from the first keystroke
/// marks a form red before anybody has finished typing their name.
///
/// One thing the finished form cannot give the agent: the error text lives
/// inside each `TextFormField`, and `get_interactive_elements` stops at the
/// field. The messages are only verifiable by screenshot. Rendering them as
/// keyed `Text` widgets under each field would make them readable from the
/// tree — a fair trade to discuss, and the reason the demo notes mention it.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _busy = false;
  bool _submitted = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  static final _emailPattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Enter your email';
    }
    if (!_emailPattern.hasMatch(email)) {
      return 'That does not look like an email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return 'Choose a password';
    }
    if (password.length < 8) {
      return 'Use at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Type your password again';
    }
    if (value != _password.text) {
      return 'The two passwords do not match';
    }
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) {
      debugPrint('[signup] blocked by validation');
      return;
    }
    setState(() => _busy = true);
    debugPrint('[signup] submit name="${_name.text}" email="${_email.text}"');

    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _busy = false);

    // pushReplacement, not push: after signing up there is nothing useful
    // behind this screen, and a back button that returns to a filled-in
    // sign-up form is its own small confusion on stage.
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => DashboardScreen(
          displayName: _name.text.trim().isEmpty ? 'there' : _name.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('signup_back_button'),
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Create account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              autovalidateMode: _submitted
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Join Togeva',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: DemoTheme.ink,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'It takes a minute. No card needed.',
                    style: TextStyle(fontSize: 15, color: DemoTheme.muted),
                  ),
                  const SizedBox(height: 26),
                  const _FieldLabel('Full name'),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('signup_name_field'),
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    validator: _validateName,
                    decoration: const InputDecoration(hintText: 'Ada Lovelace'),
                  ),
                  const SizedBox(height: 18),
                  const _FieldLabel('Email'),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('signup_email_field'),
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: _validateEmail,
                    decoration: const InputDecoration(
                      hintText: 'you@example.com',
                    ),
                  ),
                  const SizedBox(height: 18),
                  const _FieldLabel('Password'),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('signup_password_field'),
                    controller: _password,
                    obscureText: true,
                    validator: _validatePassword,
                    decoration: const InputDecoration(
                      hintText: 'At least 8 characters',
                    ),
                  ),
                  const SizedBox(height: 18),
                  const _FieldLabel('Confirm password'),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('signup_confirm_password_field'),
                    controller: _confirmPassword,
                    obscureText: true,
                    validator: _validateConfirmation,
                    decoration: const InputDecoration(
                      hintText: 'Type it again',
                    ),
                  ),
                  const SizedBox(height: 26),
                  FilledButton(
                    key: const Key('signup_submit_button'),
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
                        : const Text('Create account'),
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
