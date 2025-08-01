import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:patty_cash/src/providers/participant_provider.dart';
import 'package:patty_cash/src/providers/receipt_item_provider.dart';
import 'package:patty_cash/src/theme/app_theme.dart';
import 'package:patty_cash/src/widgets/action_button.dart';
import 'package:patty_cash/src/widgets/app_dialog.dart';

/// Screen for displaying the summary of who owes what
class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participants = ref.watch(participantNotifierProvider);
    final receiptItems = ref.watch(receiptItemNotifierProvider);
    final receiptItemNotifier = ref.read(receiptItemNotifierProvider.notifier);
    
    // Calculate the total amount
    final totalAmount = receiptItemNotifier.calculateTotalAmount();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('summary_screen.title'.tr()),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Summary header
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.accentColor,
            child: Column(
              children: [
                Text(
                  'summary_screen.total_bill_amount'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.lightTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${'summary_screen.participants_count'.tr(args: ['${participants.length}'])} • ${'summary_screen.items_count'.tr(args: ['${receiptItems.length}'])}',
                  style: const TextStyle(
                    color: AppTheme.lightTextColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Participant amounts list
          Expanded(
            child: ListView.builder(
              itemCount: participants.length,
              itemBuilder: (context, index) {
                final participant = participants[index];
                final amountOwed = receiptItemNotifier
                    .calculateTotalForParticipant(participant.id);
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.primaryColor,
                      child: Text(
                        participant.name.isNotEmpty
                            ? participant.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(participant.name),
                    subtitle: Text('summary_screen.items_count'.tr(args: ['${participant.itemIds.length}'])),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${amountOwed.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.secondaryColor,
                          ),
                        ),
                        Text(
                          'summary_screen.of_total'.tr(args: ['${(amountOwed / totalAmount * 100).toStringAsFixed(1)}']),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.lightTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ActionButton(
                  label: 'summary_screen.view_item_breakdown'.tr(),
                  icon: Icons.list_alt,
                  type: ActionButtonType.primary,
                  onPressed: () => _showItemBreakdown(context, ref),
                  fullWidth: true,
                ),
                const SizedBox(height: 8),
                ActionButton(
                  label: 'summary_screen.share_summary'.tr(),
                  icon: Icons.share,
                  type: ActionButtonType.outlined,
                  onPressed: () => _shareSummary(context, ref),
                  fullWidth: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog with the breakdown of items for each participant
  void _showItemBreakdown(BuildContext context, WidgetRef ref) {
    final participants = ref.read(participantNotifierProvider);
    final receiptItems = ref.read(receiptItemNotifierProvider);
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'summary_screen.item_breakdown'.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: participants.length,
                  itemBuilder: (context, index) {
                    final participant = participants[index];
                    final participantItems = receiptItems
                        .where((item) => item.participantIds.contains(participant.id))
                        .toList();
                    
                    return ExpansionTile(
                      title: Text(participant.name),
                      subtitle: Text('summary_screen.items_count'.tr(args: ['${participantItems.length}'])),
                      children: participantItems.map((item) {
                        return ListTile(
                          title: Text(item.name),
                          trailing: Text(
                            '\$${(item.price / item.participantIds.length).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          dense: true,
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('dialogs.close'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Generates and shares a text summary of who owes what
  void _shareSummary(BuildContext context, WidgetRef ref) {
    final participants = ref.read(participantNotifierProvider);
    final receiptItemNotifier = ref.read(receiptItemNotifierProvider.notifier);
    final totalAmount = receiptItemNotifier.calculateTotalAmount();
    
    // Generate summary text
    final StringBuffer summaryText = StringBuffer();
    summaryText.writeln('summary_screen.share_header'.tr());
    summaryText.writeln('--------------------------------');
    summaryText.writeln('${'summary_screen.total_bill'.tr()}: \$${totalAmount.toStringAsFixed(2)}');
    summaryText.writeln('');
    summaryText.writeln('summary_screen.who_owes_what'.tr());
    
    for (final participant in participants) {
      final amountOwed = receiptItemNotifier.calculateTotalForParticipant(participant.id);
      summaryText.writeln('${participant.name}: \$${amountOwed.toStringAsFixed(2)}');
    }
    
    // Copy to clipboard
    Clipboard.setData(ClipboardData(text: summaryText.toString()));
    
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('summary_screen.copied_to_clipboard'.tr()),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
