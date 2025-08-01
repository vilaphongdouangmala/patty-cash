/// Represents a participant in the meal cost splitting
class Participant {
  /// Unique identifier for the participant
  final String id;
  
  /// Name of the participant
  final String name;
  
  /// List of item IDs that this participant is responsible for
  final List<String> itemIds;

  /// Creates a new participant
  Participant({
    required this.id,
    required this.name,
    List<String>? itemIds,
  }) : itemIds = itemIds ?? [];

  /// Creates a copy of this participant with the given fields replaced with new values
  Participant copyWith({
    String? name,
    List<String>? itemIds,
  }) {
    return Participant(
      id: id,
      name: name ?? this.name,
      itemIds: itemIds ?? this.itemIds,
    );
  }

  /// Adds an item ID to this participant's list of items
  Participant addItem(String itemId) {
    final newItemIds = List<String>.from(itemIds);
    if (!newItemIds.contains(itemId)) {
      newItemIds.add(itemId);
    }
    return copyWith(itemIds: newItemIds);
  }

  /// Removes an item ID from this participant's list of items
  Participant removeItem(String itemId) {
    final newItemIds = List<String>.from(itemIds);
    newItemIds.remove(itemId);
    return copyWith(itemIds: newItemIds);
  }
}
