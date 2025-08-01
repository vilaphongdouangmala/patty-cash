import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../models/participant.dart';

part 'participant_provider.g.dart';

/// Provider for managing participants
@riverpod
class ParticipantNotifier extends _$ParticipantNotifier {
  final _uuid = const Uuid();

  @override
  List<Participant> build() {
    // Initial empty list of participants
    return [];
  }

  /// Adds a new participant with the given name
  void addParticipant(String name) {
    if (name.trim().isEmpty) return;
    
    final participant = Participant(
      id: _uuid.v4(),
      name: name.trim(),
    );
    
    state = [...state, participant];
  }

  /// Updates an existing participant
  void updateParticipant(Participant participant) {
    state = state.map((p) => p.id == participant.id ? participant : p).toList();
  }

  /// Removes a participant by ID
  void removeParticipant(String id) {
    state = state.where((p) => p.id != id).toList();
  }

  /// Gets a participant by ID
  Participant? getParticipantById(String id) {
    final index = state.indexWhere((p) => p.id == id);
    if (index == -1) return null;
    return state[index];
  }

  /// Adds an item to a participant
  void addItemToParticipant(String participantId, String itemId) {
    state = state.map((participant) {
      if (participant.id == participantId) {
        return participant.addItem(itemId);
      }
      return participant;
    }).toList();
  }

  /// Removes an item from a participant
  void removeItemFromParticipant(String participantId, String itemId) {
    state = state.map((participant) {
      if (participant.id == participantId) {
        return participant.removeItem(itemId);
      }
      return participant;
    }).toList();
  }
  
  /// Resets all participants data
  void resetAll() {
    state = [];
  }
}
