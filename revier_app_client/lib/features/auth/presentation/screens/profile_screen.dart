import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:revier_app_client/features/auth/services/auth_service.dart';
import 'package:revier_app_client/core/services/error_service.dart';
import 'package:revier_app_client/localization/app_localizations.dart';

/// A screen that displays the user's profile and account information
class ProfileScreen extends ConsumerWidget {
  /// Constructor
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final authService = ref.watch(authServiceProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        user.email?.isNotEmpty == true
                            ? user.email![0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 40,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Email
                  InfoCard(
                    title: l10n.profileEmail,
                    value: user.email ?? l10n.noEmail,
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16),

                  // User ID
                  InfoCard(
                    title: l10n.userID,
                    value: user.id,
                    icon: Icons.perm_identity,
                  ),
                  const SizedBox(height: 16),

                  // Last sign in
                  if (user.lastSignInAt != null)
                    InfoCard(
                      title: l10n.profileTitle,
                      value: _formatDate(DateTime.parse(user.lastSignInAt!)),
                      icon: Icons.calendar_today,
                    ),
                  const SizedBox(height: 16),

                  // Created at
                  if (user.createdAt != null)
                    InfoCard(
                      title: l10n.accountCreated,
                      value: _formatDate(DateTime.parse(user.createdAt!)),
                      icon: Icons.history,
                    ),

                  const SizedBox(height: 32),

                  // Account actions
                  Text(
                    l10n.accountOptions,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Change password button
                  ListTile(
                    leading: const Icon(Icons.lock_reset),
                    title: Text(l10n.changePassword),
                    onTap: () {
                      // Show dialog to change password
                      _showChangePasswordDialog(context, ref);
                    },
                  ),

                  // Sign out button
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(l10n.signOut),
                    onTap: () async {
                      try {
                        await authService.signOut();
                        // Navigate back after sign out
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ErrorService.showErrorSnackBar(context, e);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }

  // Format date into readable string
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Show dialog to change password
  void _showChangePasswordDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.changePasswordTitle),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: l10n.newPassword,
                  border: const OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.plsEnterNewPW;
                  }
                  if (value.length < 6) {
                    return l10n.pwLengthTip;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: l10n.confirmPassword,
                  border: const OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.plsConfirmPW;
                  }
                  if (value != newPasswordController.text) {
                    return l10n.passwordMismatch;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  final authService = ref.read(authServiceProvider);
                  await authService.updatePassword(newPasswordController.text);

                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.pwUpdateSuccess),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ErrorService.showErrorSnackBar(context, e);
                  }
                }
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}

/// A card widget to display user information
class InfoCard extends StatelessWidget {
  /// The title of the information
  final String title;

  /// The value to display
  final String value;

  /// The icon to display
  final IconData icon;

  /// Constructor
  const InfoCard({
    required this.title,
    required this.value,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
