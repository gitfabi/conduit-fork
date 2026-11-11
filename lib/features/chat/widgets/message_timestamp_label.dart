import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../shared/theme/theme_extensions.dart';

/// When a message was sent, as the web client's hover time but always visible:
/// the time for today, "Nov 9, 9:41 AM" earlier this year, and the year too
/// for older messages. Follows the device's 12 or 24 hour setting and locale.
String formatMessageTimestamp(
  DateTime timestamp, {
  required String locale,
  required DateTime now,
  required bool use24HourTime,
}) {
  final local = timestamp.toLocal();
  final time = use24HourTime
      ? DateFormat.Hm(locale).format(local)
      : DateFormat.jm(locale).format(local);
  final sameDay =
      local.year == now.year && local.month == now.month && local.day == now.day;
  if (sameDay) return time;
  final date = local.year == now.year
      ? DateFormat.MMMd(locale).format(local)
      : DateFormat.yMMMd(locale).format(local);
  return '$date, $time';
}

/// A small, quiet timestamp under a message.
class MessageTimestampLabel extends StatelessWidget {
  const MessageTimestampLabel({super.key, required this.timestamp});

  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    final text = formatMessageTimestamp(
      timestamp,
      locale: Localizations.localeOf(context).toString(),
      now: DateTime.now(),
      use24HourTime: MediaQuery.alwaysUse24HourFormatOf(context),
    );
    return Text(
      text,
      key: const Key('message-timestamp'),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTypography.labelSmallStyle.copyWith(
        color: context.conduitTheme.textSecondary,
      ),
    );
  }
}

/// The timestamp of a chat message of unknown static type, or null.
DateTime? messageTimestampOf(dynamic message) {
  try {
    final value = message.timestamp;
    return value is DateTime ? value : null;
  } on NoSuchMethodError {
    return null;
  }
}
