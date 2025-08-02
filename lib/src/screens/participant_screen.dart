import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:patty_cash/src/models/participant.dart';
import 'package:patty_cash/src/providers/participant_provider.dart';
import 'package:patty_cash/src/theme/app_theme.dart';
import 'package:patty_cash/src/widgets/action_button.dart';
import 'package:patty_cash/src/widgets/app_dialog.dart';

/// Screen for managing participants
class ParticipantScreen extends ConsumerStatefulWidget {
  const ParticipantScreen({super.key});

  @override
  ConsumerState<ParticipantScreen> createState() => _ParticipantScreenState();
}

class _ParticipantScreenState extends ConsumerState<ParticipantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _editingParticipantId;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final participants = ref.watch(participantNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('participant_screen.title'.tr()),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Participants list
          Expanded(
            child: participants.isEmpty
                ? Center(
                    child: Text(
                      'participant_screen.no_participants'.tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.lightTextColor,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: participants.length,
                    itemBuilder: (context, index) {
                      final participant = participants[index];
                      return _buildParticipantCard(participant);
                    },
                  ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'participant_screen.participant_name'.tr(),
                        hintText: 'participant_screen.enter_name'.tr(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'participant_screen.please_enter_name'.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  ActionButton(
                    label: _editingParticipantId == null
                        ? 'participant_screen.add'.tr()
                        : 'participant_screen.update'.tr(),
                    icon: _editingParticipantId == null
                        ? Icons.add
                        : Icons.update,
                    type: ActionButtonType.primary,
                    onPressed: _submitForm,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
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
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// Builds a card for displaying a participant
  Widget _buildParticipantCard(Participant participant) {
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
        subtitle: Text('participant_screen.items_selected'.tr(namedArgs: {
          'count': participant.itemIds.length.toString(),
        })),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: AppTheme.secondaryColor,
              onPressed: () => _startEditingParticipant(participant),
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () => _showDeleteConfirmation(participant),
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }

  /// Submits the form to add or update a participant
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();

      if (_editingParticipantId != null) {
        // Update existing participant
        final participantNotifier =
            ref.read(participantNotifierProvider.notifier);
        final participant =
            participantNotifier.getParticipantById(_editingParticipantId!);

        if (participant != null) {
          final updatedParticipant = participant.copyWith(name: name);
          participantNotifier.updateParticipant(updatedParticipant);
        }

        // Reset editing state
        setState(() {
          _editingParticipantId = null;
        });
      } else {
        // Add new participant
        ref.read(participantNotifierProvider.notifier).addParticipant(name);
      }

      // Clear the form
      _nameController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  /// Starts editing a participant
  void _startEditingParticipant(Participant participant) {
    setState(() {
      _editingParticipantId = participant.id;
      _nameController.text = participant.name;
    });

    // Focus the text field
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /// Shows a confirmation dialog before deleting a participant
  void _showDeleteConfirmation(Participant participant) {
    AppDialog.showConfirmation(
      context: context,
      title: 'participant_screen.delete_participant'.tr(),
      message: 'participant_screen.delete_participant_confirm'
          .tr(namedArgs: {'name': participant.name}),
      cancelText: 'participant_screen.cancel'.tr(),
      confirmText: 'participant_screen.delete'.tr(),
      confirmColor: Colors.red,
    ).then((confirmed) {
      if (confirmed) {
        ref
            .read(participantNotifierProvider.notifier)
            .removeParticipant(participant.id);
      }
    });
  }
}
