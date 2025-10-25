import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/features/hunting_ground/hunting_ground_form_view.dart';
import 'package:revier_app_client/common/navigation/navigation_service.dart';
import 'package:revier_app_client/localization/app_localizations.dart';

/// Screen for creating a new hunting ground
class HuntingGroundCreateScreen extends ConsumerWidget {
  const HuntingGroundCreateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createHuntingGround),
      ),
      body: HuntingGroundFormView(
        navigateToMainAfterSave: true,
        onCancel: () => NavigationService.instance.goBack(),
        onSave: (_) {
          // Navigate back after saving - the caller will refresh the list
          NavigationService.instance.goBack();
        },
      ),
    );
  }
}
