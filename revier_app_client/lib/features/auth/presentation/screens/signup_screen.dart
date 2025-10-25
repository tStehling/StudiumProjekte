import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revier_app_client/features/auth/services/auth_service.dart';
import 'package:revier_app_client/core/services/error_service.dart';
import 'package:revier_app_client/localization/app_localizations.dart';

/// A screen that allows users to sign up with email and password
class SignupScreen extends HookConsumerWidget {
  /// Constructor
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final formKey = GlobalKey<FormState>();
    final isLoading = useState(false);
    final authService = ref.watch(authServiceProvider);

    // Handle sign up
    void handleSignUp() async {
      if (!formKey.currentState!.validate()) {
        return;
      }

      try {
        isLoading.value = true;

        await authService.signUpWithEmail(
          emailController.text.trim(),
          passwordController.text,
        );

        if (context.mounted) {
          // Update authentication state
          ref.read(isSignedInProvider.notifier).state = true;

          // Navigate back or show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.registrationSuccessful),
            ),
          );
          Navigator.of(context).pop(); // Return to previous screen
        }
      } catch (e) {
        if (context.mounted) {
          ErrorService.showErrorSnackBar(context, e);
        }
      } finally {
        if (context.mounted) {
          isLoading.value = false;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.signUp),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App logo or icon
                Icon(
                  Icons.forest,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 32),

                // App name
                Text(
                  l10n.appTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 32),

                // Email input
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: l10n.email,
                    hintText: l10n.email,
                    prefixIcon: const Icon(Icons.email),
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.emailRequired;
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return l10n.emailInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password input
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    hintText: l10n.passwordHint,
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.passwordRequired;
                    }
                    if (value.length < 6) {
                      return l10n.passwordTooShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm password input
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: l10n.confirmPassword,
                    hintText: l10n.confirmPasswordHint,
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.confirmPasswordRequired;
                    }
                    if (value != passwordController.text) {
                      return l10n.passwordMismatch;
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => handleSignUp(),
                ),
                const SizedBox(height: 24),

                // Sign up button
                ElevatedButton(
                  onPressed: isLoading.value ? null : handleSignUp,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: isLoading.value
                      ? const CircularProgressIndicator()
                      : Text(l10n.signUp),
                ),
                const SizedBox(height: 16),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.alreadyHaveAccount),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(l10n.signIn),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
