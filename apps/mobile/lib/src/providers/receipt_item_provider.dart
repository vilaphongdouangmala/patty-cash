import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../models/receipt_item.dart';

part 'receipt_item_provider.g.dart';

/// Provider for managing receipt items
@riverpod
class ReceiptItemNotifier extends _$ReceiptItemNotifier {
  final _uuid = const Uuid();

  @override
  List<ReceiptItem> build() {
    // Initial empty list of receipt items
    return [];
  }

  /// Adds a new receipt item
  void addItem(String name, double price) {
    if (name.trim().isEmpty || price <= 0) return;
    
    final item = ReceiptItem(
      id: _uuid.v4(),
      name: name.trim(),
      price: price,
    );
    
    state = [...state, item];
  }

  /// Updates an existing receipt item
  void updateItem(ReceiptItem item) {
    state = state.map((i) => i.id == item.id ? item : i).toList();
  }

  /// Removes a receipt item by ID
  void removeItem(String id) {
    state = state.where((i) => i.id != id).toList();
  }

  /// Gets a receipt item by ID
  ReceiptItem? getItemById(String id) {
    final index = state.indexWhere((i) => i.id == id);
    if (index == -1) return null;
    return state[index];
  }

  /// Adds a participant to a receipt item
  void addParticipantToItem(String itemId, String participantId) {
    state = state.map((item) {
      if (item.id == itemId) {
        return item.addParticipant(participantId);
      }
      return item;
    }).toList();
  }

  /// Removes a participant from a receipt item
  void removeParticipantFromItem(String itemId, String participantId) {
    state = state.map((item) {
      if (item.id == itemId) {
        return item.removeParticipant(participantId);
      }
      return item;
    }).toList();
  }

  /// Calculates the total amount owed by a participant
  double calculateTotalForParticipant(String participantId) {
    double total = 0;
    
    for (final item in state) {
      if (item.participantIds.contains(participantId)) {
        total += item.getPricePerParticipant();
      }
    }
    
    return total;
  }

  /// Calculates the total amount of all items
  double calculateTotalAmount() {
    return state.fold(0, (sum, item) => sum + item.price);
  }
  
  /// Resets all receipt items data
  void resetAll() {
    state = [];
  }
}
