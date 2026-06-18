import 'package:flutter/material.dart';

import '../../config/app_env.dart';
import '../../runtime/backend_link.dart';
import '../../runtime/signal_relay.dart';
import '../../runtime/trace_beacon.dart';
import '../../theme/sky_palette.dart';
import '../../theme/sky_type.dart';
import '../../widgets/aircraft_silhouette.dart';
import '../../widgets/lift_button.dart';
import '../../widgets/sky_card.dart';

class AccessScreen extends StatefulWidget {
  final VoidCallback onDone;
  const AccessScreen({super.key, required this.onDone});

  @override
  State<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _createMode = false;
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _submit() async {
    if (!AppEnv.hasSupabase) {
      _toast('Accounts are unavailable right now.');
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      if (_createMode) {
        final res = await BackendLink.enroll(_email.text.trim(), _pass.text);
        TraceBeacon.registration();
        final uid = res.user?.id;
        if (uid != null) await SignalRelay.bindUser(uid);
        _toast('Account created. Check your inbox to confirm.');
      } else {
        final res = await BackendLink.signIn(_email.text.trim(), _pass.text);
        TraceBeacon.login();
        final uid = res.user?.id;
        if (uid != null) await SignalRelay.bindUser(uid);
      }
      if (!mounted) return;
      widget.onDone();
    } catch (e) {
      _toast(_humanError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _humanError(Object e) {
    final s = e.toString();
    if (s.contains('Invalid login')) return 'Wrong email or password.';
    if (s.contains('already registered')) {
      return 'This email is already registered.';
    }
    return 'Something went wrong. Please try again.';
  }

  Future<void> _forgotPassword() async {
    final email = _email.text.trim();
    if (email.isEmpty) {
      _toast('Enter your email first, then tap reset.');
      return;
    }
    try {
      await BackendLink.resetPassword(email);
      _toast('Password reset link sent.');
    } catch (_) {
      _toast('Could not send reset link.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: SkyPalette.skyWashGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GhostLink(
                    label: 'Skip for now',
                    onPressed: _busy ? null : widget.onDone,
                  ),
                ),
                const SizedBox(height: 8),
                const AircraftSilhouette(
                    size: 44, heading: 30, color: SkyPalette.skyDeep),
                const SizedBox(height: 14),
                Text(_createMode ? 'Start your logbook' : 'Welcome aboard',
                    style: SkyType.title()),
                const SizedBox(height: 8),
                Text(
                  'An account backs up your spotting log across devices and powers flight alerts. It is optional — the tracker works fully offline.',
                  style: SkyType.body(),
                ),
                const SizedBox(height: 24),
                SkyCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.mail_outline_rounded),
                          ),
                          validator: (v) {
                            final t = (v ?? '').trim();
                            if (t.isEmpty || !t.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _pass,
                          obscureText: true,
                          autofillHints: const [AutofillHints.password],
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                          ),
                          validator: (v) {
                            if ((v ?? '').length < 6) {
                              return 'At least 6 characters';
                            }
                            return null;
                          },
                        ),
                        if (!_createMode) ...[
                          Align(
                            alignment: Alignment.centerRight,
                            child: GhostLink(
                              label: 'Forgot password?',
                              onPressed: _busy ? null : _forgotPassword,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        LiftButton(
                          label: _createMode ? 'Create account' : 'Sign in',
                          busy: _busy,
                          onPressed: _busy ? null : _submit,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => setState(() => _createMode = !_createMode),
                  child: Text(
                    _createMode
                        ? 'I already have an account'
                        : 'New here? Create an account',
                    style: SkyType.label(color: SkyPalette.skyDeep),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
