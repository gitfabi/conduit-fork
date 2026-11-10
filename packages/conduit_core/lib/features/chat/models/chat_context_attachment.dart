import 'package:meta/meta.dart';

/// Represents a non-file attachment that enriches a chat message,
/// such as a web page, YouTube video transcript, existing note,
/// or a reference to a knowledge base document or a whole knowledge base
/// ([ChatContextAttachmentType.knowledgeBase], whose [fileId] is the base id).
@immutable
class ChatContextAttachment {
  const ChatContextAttachment({
    required this.id,
    required this.type,
    required this.displayName,
    this.url,
    this.content,
    this.collectionName,
    this.fileId,
  });

  final String id;
  final ChatContextAttachmentType type;
  final String displayName;
  final String? url;
  final String? content;
  final String? collectionName;
  final String? fileId;
}

enum ChatContextAttachmentType { web, youtube, knowledge, knowledgeBase, note }
