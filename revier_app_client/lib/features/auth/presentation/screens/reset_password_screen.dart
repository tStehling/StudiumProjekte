import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revier_app_client/features/auth/services/auth_service.dart';
import 'package:revier_app_client/core/services/error_service.dart';
import 'package:revier_app_client/localization/app_localizations.dart';

/// A screen that allows users to reset their password
class ResetPasswordScreen extends HookConsumerWidget {
  /// Constructor
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final emailController = useTextEditingController();
    final formKey = GlobalKey<FormState>();
    final isLoading = useState(false);
    final isEmailSent = useState(false);
    final authService = ref.watch(authServiceProvider);

    // Handle password reset
    void handleResetPassword() async {
      if (!formKey.currentState!.validate()) {
        return;
      }

      try {
        isLoading.value = true;
        await authService.resetPassword(emailController.text.trim());

        if (context.mounted) {
          isEmailSent.value = true;
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
        title: Text(l10n.resetPasswordTitle),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: isEmailSent.value
              ? _buildSuccessContent(context, l10n)
              : _buildResetForm(
                  context,
                  l10n,
                  formKey,
                  emailController,
                  isLoading.value,
                  handleResetPassword,
                ),
        ),
      ),
    );
  }

  // Form to enter email for password reset
  Widget _buildResetForm(
    BuildContext context,
    AppLocalizations l10n,
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
    bool isLoading,
    VoidCallback onSubmit,
  ) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon
          Icon(
            Icons.lock_reset,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 32),

          Text(
            l10n.resetPasswordTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),

          Text(
            l10n.resetPasswordInstructions,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),

          // Email input
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: l10n.email,
              hintText: l10n.emailHint,
              prefixIcon: const Icon(Icons.email),
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
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
            onFieldSubmitted: (_) => onSubmit(),
          ),
          const SizedBox(height: 24),

          // Reset button
          ElevatedButton(
            onPressed: isLoading ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: isLoading
                ? const CircularProgressIndicator()
                : Text(l10n.resetPasswordButton),
          ),
        ],
      ),
    );
  }

  // Content to show after successful email submission
  Widget _buildSuccessContent(BuildContext context, AppLocalizations l10n) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.mark_email_read,
          size: 80,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 32),
        Text(
          l10n.checkEmail,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.resetLinkSent,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: Text(l10n.backToLogin),
        ),
      ],
    );
  }
}
