import 'package:flutter/material.dart';
import 'package:marionette_demo/core/theme.dart';
import 'package:marionette_demo/features/dashboard/dashboard_screen.dart';

/// Demo 04 — "Can you verify your own work?"
///
/// The form has no validation at all. An empty submit creates an account, and
/// so does "not-an-email". That is the task: the agent adds the rules, then
/// drives every state in the running app to prove they hold.
///
/// Two details that make the demo work. The fields are plain `TextField`s,
/// so the agent has to choose its own approach — `Form` plus validators, or
/// error state held here and rendered as keyed `Text`. And the submit is
/// slow enough (500 ms) to be observable, so "did it accept that?" is a
/// question it has to look twice to answer.
///
/// Note for whoever watches the agent work: error text living inside a
/// `TextFormField` does not come back from `get_interactive_elements`, which
/// stops at the field. Verifying that route means `take_screenshots`.
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
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  /// Accepts anything, including nothing at all — that is the bug the demo
  /// asks the agent to close. The keyboard is dismissed first so a screenshot
  /// taken straight after shows the whole form rather than its top half.
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
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
                TextField(
                  key: const Key('signup_name_field'),
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(hintText: 'Ada Lovelace'),
                ),
                const SizedBox(height: 18),
                const _FieldLabel('Email'),
                const SizedBox(height: 8),
                TextField(
                  key: const Key('signup_email_field'),
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'you@example.com',
                  ),
                ),
                const SizedBox(height: 18),
                const _FieldLabel('Password'),
                const SizedBox(height: 8),
                TextField(
                  key: const Key('signup_password_field'),
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'At least 8 characters',
                  ),
                ),
                const SizedBox(height: 18),
                const _FieldLabel('Confirm password'),
                const SizedBox(height: 8),
                TextField(
                  key: const Key('signup_confirm_password_field'),
                  controller: _confirmPassword,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Type it again'),
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
