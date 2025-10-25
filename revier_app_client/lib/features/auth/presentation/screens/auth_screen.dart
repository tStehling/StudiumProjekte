import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/core/services/error_service.dart';
import 'package:revier_app_client/localization/app_localizations.dart';
import 'package:revier_app_client/features/auth/services/auth_service.dart';
import 'package:revier_app_client/core/providers/locale_provider.dart';
import 'package:revier_app_client/core/services/logging_service.dart';

/// A screen that handles authentication (login and registration)
class AuthScreen extends ConsumerStatefulWidget {
  /// Creates an authentication screen
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  static final _log = loggingService.getLogger('AuthScreen');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLogin = true; // Toggle between login and registration

  /// Mask email for logging purposes to protect user privacy
  String _maskEmail(String email) {
    if (email.isEmpty) return '';
    final parts = email.split('@');
    if (parts.length != 2) return 'invalid-email';

    String name = parts[0];
    String domain = parts[1];

    if (name.length <= 2) {
      return '${name.substring(0, 1)}***@$domain';
    } else {
      return '${name.substring(0, 2)}***@$domain';
    }
  }

  @override
  void initState() {
    super.initState();
    _log.info(
        'AuthScreen initialized, mode: ${_isLogin ? 'Login' : 'Registration'}');
  }

  @override
  void dispose() {
    _log.debug('Disposing AuthScreen controllers');
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      _log.warning('Form validation failed');
      return;
    }

    _log.info(
        'Submitting authentication form, mode: ${_isLogin ? 'Login' : 'Registration'}');
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final email = _emailController.text.trim();

      _log.info(
          'Attempting to ${_isLogin ? 'sign in' : 'sign up'} user: ${_maskEmail(email)}');

      if (_isLogin) {
        // Login
        await authService.signInWithEmail(
          email,
          _passwordController.text,
        );
        _log.info('Login successful');
      } else {
        // Register
        await authService.signUpWithEmail(
          email,
          _passwordController.text,
        );
        _log.info('Registration successful');
      }

      // Update the auth state
      ref.read(isSignedInProvider.notifier).state = true;
    } catch (error) {
      _log.error('Authentication error: ${error.toString()}');
      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;
      ErrorService.showErrorSnackBar(
        context,
        error,
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithGoogle();
      // Auth state will be handled by the redirect
    } catch (e) {
      // Handle errors
      if (mounted) {
        ErrorService.showErrorSnackBar(context, e);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resetPassword() async {
    final l10n = AppLocalizations.of(context);

    // Show a dialog to enter email
    final email = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetPasswordTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.resetPasswordInstructions),
            const SizedBox(height: 16),
            TextFormField(
              controller: TextEditingController(text: _emailController.text),
              decoration: InputDecoration(
                labelText: l10n.email,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.of(context).pop(_emailController.text.trim()),
            child: Text(l10n.send),
          ),
        ],
      ),
    );

    if (email == null || email.isEmpty) return;

    _log.info('Password reset requested for: ${_maskEmail(email)}');
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.resetPassword(email);
      _log.info('Password reset email sent successfully');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.resetLinkSent),
        ),
      );
    } catch (error) {
      _log.error('Password reset error: ${error.toString()}');
      if (!mounted) return;
      ErrorService.showErrorSnackBar(
        context,
        error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _toggleLanguage() {
    final currentLocale = ref.read(localeProvider);
    // Toggle between English and German
    final newLocale = currentLocale.languageCode == 'en'
        ? const Locale('de')
        : const Locale('en');
    ref.read(localeProvider.notifier).state = newLocale;
  }

  void _toggleAuthMode() {
    _log.debug(
        'Toggling auth mode from ${_isLogin ? 'Login' : 'Registration'} to ${!_isLogin ? 'Login' : 'Registration'}');
    setState(() {
      _isLogin = !_isLogin;
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    _log.debug(
        'Building AuthScreen, mode: ${_isLogin ? 'Login' : 'Registration'}');
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);

    // // Listen to the auth state
    // final isSignedIn = ref.watch(isSignedInProvider);

    // // If user becomes signed in while on this screen, handle accordingly
    // if (isSignedIn && !_isLoading) {
    //   // Give the UI time to update
    //   Future.microtask(() {
    //     // Navigate away from auth screen or otherwise handle the signed-in state
    //     // Depending on your navigation setup, you might do something like:
    //     // Navigator.of(context).pushReplacementNamed('/home');
    //   });
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isLogin ? l10n.signIn : l10n.signUp,
        ),
        actions: [
          // Language toggle button
          IconButton(
            icon: Text(
              currentLocale.languageCode.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            tooltip: l10n.changeLanguage,
            onPressed: _toggleLanguage,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App logo or name
                Icon(
                  Icons.nature,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 32),

                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: l10n.email,
                    prefixIcon: const Icon(Icons.email),
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.emailRequired;
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return l10n.emailInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.passwordRequired;
                    }
                    if (!_isLogin && value.length < 6) {
                      return l10n.passwordTooShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm password field (only for registration)
                if (!_isLogin)
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: l10n.confirmPassword,
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.confirmPasswordRequired;
                      }
                      if (value != _passwordController.text) {
                        return l10n.passwordMismatch;
                      }
                      return null;
                    },
                  ),

                // Forgot password (only for login)
                if (_isLogin)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _resetPassword,
                      child: Text(l10n.forgotPassword),
                    ),
                  ),
                const SizedBox(height: 24),

                // Submit button
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          _isLogin ? l10n.signIn : l10n.signUp,
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 16),

                // Toggle between login and registration
                TextButton(
                  onPressed: _toggleAuthMode,
                  child: Text(
                    _isLogin ? l10n.dontHaveAccount : l10n.alreadyHaveAccount,
                  ),
                ),
                const SizedBox(height: 24),

                // Or continue with divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(l10n.orContinueWith),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),

                // Google sign in button
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    height: 24,
                  ),
                  label: Text(l10n.signInWithGoogle),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
