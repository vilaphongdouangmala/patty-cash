import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:patty_cash/src/models/receipt_item.dart';
import 'package:patty_cash/src/providers/participant_provider.dart';
import 'package:patty_cash/src/providers/receipt_item_provider.dart';
import 'package:patty_cash/src/theme/app_theme.dart';
import 'package:patty_cash/src/widgets/action_button.dart';
import 'package:patty_cash/src/widgets/app_dialog.dart';

/// Screen for managing receipt items
class ReceiptScreen extends ConsumerStatefulWidget {
  const ReceiptScreen({super.key});

  @override
  ConsumerState<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends ConsumerState<ReceiptScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String? _editingItemId;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final receiptItems = ref.watch(receiptItemNotifierProvider);
    final totalAmount =
        ref.read(receiptItemNotifierProvider.notifier).calculateTotalAmount();

    return Scaffold(
      appBar: AppBar(
        title: Text('receipt_screen.title'.tr()),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Add receipt item form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'receipt_screen.item_name'.tr(),
                            hintText: 'receipt_screen.enter_item_name'.tr(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'receipt_screen.please_enter_item_name'
                                  .tr();
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _priceController,
                          decoration: InputDecoration(
                            labelText: 'receipt_screen.price'.tr(),
                            hintText: '0.00',
                            prefixText: '฿',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}'),
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'receipt_screen.required'.tr();
                            }
                            final price = double.tryParse(value);
                            if (price == null || price <= 0) {
                              return 'receipt_screen.invalid_price'.tr();
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ActionButton(
                    label: _editingItemId == null
                        ? 'receipt_screen.add_item'.tr()
                        : 'receipt_screen.update_item'.tr(),
                    icon: _editingItemId == null ? Icons.add : Icons.update,
                    type: ActionButtonType.primary,
                    onPressed: _submitForm,
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          ),

          // Total amount display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppTheme.accentColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'receipt_screen.total_amount'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '฿${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.secondaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Receipt items list
          Expanded(
            child: receiptItems.isEmpty
                ? const Center(
                    child: Text(
                      'No receipt items yet.\nAdd items to get started!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.lightTextColor,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: receiptItems.length,
                    itemBuilder: (context, index) {
                      final item = receiptItems[index];
                      return _buildReceiptItemCard(item);
                    },
                  ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  label: 'common.done'.tr(),
                  icon: Icons.check,
                  type: ActionButtonType.secondary,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a card for displaying a receipt item
  Widget _buildReceiptItemCard(ReceiptItem item) {
    final participants = ref.watch(participantNotifierProvider);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            title: Text(item.name),
            subtitle: Text(
              '${item.participantIds.length} ${'receipt_screen.participants'.tr()} • ฿${(item.price / (item.participantIds.isEmpty ? 1 : item.participantIds.length)).toStringAsFixed(2)} ${'receipt_screen.each'.tr()}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '฿${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: AppTheme.secondaryColor,
                  onPressed: () => _startEditingItem(item),
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () => _showDeleteConfirmation(item),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),

          // Participant selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'receipt_screen.whos_paying'.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.lightTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: participants.map((participant) {
                    final isSelected =
                        item.participantIds.contains(participant.id);

                    return FilterChip(
                      label: Text(participant.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        _toggleParticipantForItem(
                            item, participant.id, selected);
                      },
                      backgroundColor: Colors.white,
                      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                      checkmarkColor: AppTheme.primaryColor,
                      side: BorderSide(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : Colors.grey.shade300,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Submits the form to add or update a receipt item
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final price = double.parse(_priceController.text);

      if (_editingItemId != null) {
        // Update existing item
        final itemNotifier = ref.read(receiptItemNotifierProvider.notifier);
        final item = itemNotifier.getItemById(_editingItemId!);

        if (item != null) {
          final updatedItem = item.copyWith(
            name: name,
            price: price,
          );
          itemNotifier.updateItem(updatedItem);
        }

        // Reset editing state
        setState(() {
          _editingItemId = null;
        });
      } else {
        // Add new item
        ref.read(receiptItemNotifierProvider.notifier).addItem(name, price);
      }

      // Clear the form
      _nameController.clear();
      _priceController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  /// Starts editing a receipt item
  void _startEditingItem(ReceiptItem item) {
    setState(() {
      _editingItemId = item.id;
      _nameController.text = item.name;
      _priceController.text = item.price.toString();
    });

    // Focus the text field
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /// Shows a confirmation dialog before deleting a receipt item
  void _showDeleteConfirmation(ReceiptItem item) {
    AppDialog.showConfirmation(
      context: context,
      title: 'receipt_screen.delete_item'.tr(),
      message: 'receipt_screen.delete_item_confirm'.tr(args: [item.name]),
      cancelText: 'dialogs.cancel'.tr(),
      confirmText: 'participant_screen.delete'.tr(),
      confirmColor: Colors.red,
    ).then((confirmed) {
      if (confirmed) {
        ref.read(receiptItemNotifierProvider.notifier).removeItem(item.id);
      }
    });
  }

  /// Toggles a participant for a receipt item
  void _toggleParticipantForItem(
    ReceiptItem item,
    String participantId,
    bool selected,
  ) {
    final itemNotifier = ref.read(receiptItemNotifierProvider.notifier);
    final participantNotifier = ref.read(participantNotifierProvider.notifier);

    if (selected) {
      // Add participant to item
      itemNotifier.addParticipantToItem(item.id, participantId);
      participantNotifier.addItemToParticipant(participantId, item.id);
    } else {
      // Remove participant from item
      itemNotifier.removeParticipantFromItem(item.id, participantId);
      participantNotifier.removeItemFromParticipant(participantId, item.id);
    }
  }
}
