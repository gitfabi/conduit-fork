import 'package:checks/checks.dart';
import 'package:conduit_core/features/chat/models/chat_context_attachment.dart';
import 'package:conduit_core/features/chat/providers/chat_providers.dart';
import 'package:conduit_core/features/chat/providers/context_attachments_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  group('ContextAttachmentsNotifier', () {
    test('addNote stores a single note attachment per note id', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(contextAttachmentsProvider.notifier);
      notifier.addNote(noteId: 'note-1', displayName: 'Sprint Plan');
      notifier.addNote(noteId: 'note-1', displayName: 'Sprint Plan');

      final attachments = container.read(contextAttachmentsProvider);
      check(attachments).has((it) => it.length, 'length').equals(1);
      check(attachments.single.id).equals('note-1');
      check(attachments.single.displayName).equals('Sprint Plan');
      check(attachments.single.type).equals(ChatContextAttachmentType.note);
    });

    test('addKnowledgeBase keeps one chip per base and sends a collection', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(contextAttachmentsProvider.notifier);
      notifier.addKnowledgeBase(baseId: 'kb-1', displayName: 'Handbook');
      notifier.addKnowledgeBase(baseId: 'kb-1', displayName: 'Handbook');
      notifier.addKnowledgeBase(baseId: 'kb-2', displayName: 'Contracts');

      final attachments = container.read(contextAttachmentsProvider);
      check(attachments).has((it) => it.length, 'length').equals(2);
      check(
        attachments.first.type,
      ).equals(ChatContextAttachmentType.knowledgeBase);

      final files = contextAttachmentsToFilesForTest(attachments);
      check(files.first).deepEquals({
        'type': 'collection',
        'id': 'kb-1',
        'name': 'Handbook',
      });
    });
  });
}
