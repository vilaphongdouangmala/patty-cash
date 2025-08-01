import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:patty_cash/src/extensions/context_extensions.dart';
import 'package:patty_cash/src/providers/participant_provider.dart';
import 'package:patty_cash/src/providers/receipt_item_provider.dart';
import 'package:patty_cash/src/screens/participant_screen.dart';
import 'package:patty_cash/src/screens/receipt_screen.dart';
import 'package:patty_cash/src/screens/summary_screen.dart';
import 'package:patty_cash/src/theme/app_theme.dart';
import 'package:patty_cash/src/widgets/action_button.dart';
import 'package:patty_cash/src/widgets/app_dialog.dart';
import 'package:patty_cash/src/widgets/language_selector.dart';
import 'package:patty_cash/src/widgets/status_card.dart';

/// Home screen for the Patty Cash app
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participants = ref.watch(participantNotifierProvider);
    final receiptItems = ref.watch(receiptItemNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('home_screen.title'.tr()),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.receipt_long,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'app_title'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Select Language'),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const LanguageSelector(),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('dialogs.close'.tr()),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status cards
              SizedBox(
                height: context.contextHeight() * 0.2,
                child: Row(
                  children: [
                    Expanded(
                      child: StatusCard(
                        icon: Icons.people,
                        title: 'home_screen.participants_count'.tr(),
                        items: participants.map((item) => item.name).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Status cards
              Container(
                constraints: BoxConstraints(
                  minHeight: context.contextHeight() * 0.2,
                  maxHeight: context.contextHeight() * 0.3,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: StatusCard(
                        icon: Icons.receipt_long,
                        title: 'home_screen.receipt_items_count'.tr(),
                        items: receiptItems.map((item) => item.name).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Action buttons
              ActionButton(
                label: 'home_screen.manage_participants'.tr(),
                icon: Icons.people,
                type: ActionButtonType.primary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ParticipantScreen()),
                  );
                },
              ),

              const SizedBox(height: 16),

              ActionButton(
                label: 'home_screen.manage_receipt_items'.tr(),
                icon: Icons.receipt_long,
                type: ActionButtonType.primary,
                onPressed: () {
                  if (participants.isEmpty) {
                    _showNoParticipantsDialog(context);
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReceiptScreen()),
                  );
                },
              ),

              const SizedBox(height: 16),

              ActionButton(
                label: 'home_screen.view_split_summary'.tr(),
                icon: Icons.calculate,
                type: ActionButtonType.secondary,
                onPressed: () {
                  if (participants.isEmpty || receiptItems.isEmpty) {
                    _showIncompleteSplitDialog(context);
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SummaryScreen()),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Reset all button
              ActionButton(
                label: 'home_screen.reset_all_data'.tr(),
                icon: Icons.refresh,
                type: ActionButtonType.destructive,
                onPressed: () => _showResetConfirmationDialog(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows a dialog when trying to manage receipt items without participants
  void _showNoParticipantsDialog(BuildContext context) {
    AppDialog.showAlert(
      context: context,
      title: 'dialogs.no_participants_title'.tr(),
      message: 'dialogs.no_participants_message'.tr(),
      buttonText: 'home_screen.manage_participants'.tr(),
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ParticipantScreen()),
        );
      },
    );
  }

  /// Shows a dialog when trying to view summary without participants or items
  void _showIncompleteSplitDialog(BuildContext context) {
    AppDialog.showAlert(
      context: context,
      title: 'dialogs.incomplete_split_title'.tr(),
      message: 'dialogs.incomplete_split_message'.tr(),
    );
  }

  /// Shows a confirmation dialog before resetting all data
  void _showResetConfirmationDialog(BuildContext context, WidgetRef ref) {
    AppDialog.showConfirmation(
      context: context,
      title: 'dialogs.reset_confirmation_title'.tr(),
      message: 'dialogs.reset_confirmation_message'.tr(),
      cancelText: 'dialogs.cancel'.tr(),
      confirmText: 'dialogs.reset'.tr(),
      confirmColor: Colors.red,
    ).then((confirmed) {
      if (confirmed) {
        // Reset all data
        ref.read(participantNotifierProvider.notifier).resetAll();
        ref.read(receiptItemNotifierProvider.notifier).resetAll();

        if (context.mounted) {
          // Show confirmation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('notifications.all_data_reset'.tr()),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    });
  }
}
