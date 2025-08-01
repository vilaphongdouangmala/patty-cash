/// Represents an item on a receipt
class ReceiptItem {
  /// Unique identifier for the item
  final String id;
  
  /// Name of the item
  final String name;
  
  /// Price of the item
  final double price;
  
  /// List of participant IDs who are sharing this item
  final List<String> participantIds;

  /// Creates a new receipt item
  ReceiptItem({
    required this.id,
    required this.name,
    required this.price,
    List<String>? participantIds,
  }) : participantIds = participantIds ?? [];

  /// Creates a copy of this receipt item with the given fields replaced with new values
  ReceiptItem copyWith({
    String? name,
    double? price,
    List<String>? participantIds,
  }) {
    return ReceiptItem(
      id: id,
      name: name ?? this.name,
      price: price ?? this.price,
      participantIds: participantIds ?? this.participantIds,
    );
  }

  /// Adds a participant ID to this item's list of participants
  ReceiptItem addParticipant(String participantId) {
    final newParticipantIds = List<String>.from(participantIds);
    if (!newParticipantIds.contains(participantId)) {
      newParticipantIds.add(participantId);
    }
    return copyWith(participantIds: newParticipantIds);
  }

  /// Removes a participant ID from this item's list of participants
  ReceiptItem removeParticipant(String participantId) {
    final newParticipantIds = List<String>.from(participantIds);
    newParticipantIds.remove(participantId);
    return copyWith(participantIds: newParticipantIds);
  }

  /// Gets the price per participant for this item
  double getPricePerParticipant() {
    if (participantIds.isEmpty) return 0;
    return price / participantIds.length;
  }
}
