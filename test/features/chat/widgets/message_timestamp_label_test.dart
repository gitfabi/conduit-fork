import 'package:conduit/features/chat/widgets/message_timestamp_label.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting());

  final now = DateTime(2026, 11, 11, 15, 30);

  String fmt(DateTime t, {bool h24 = false}) => formatMessageTimestamp(
    t,
    locale: 'en',
    now: now,
    use24HourTime: h24,
  );

  test('today shows only the time', () {
    expect(fmt(DateTime(2026, 11, 11, 9, 41)), contains('9:41'));
    expect(fmt(DateTime(2026, 11, 11, 9, 41)), isNot(contains('Nov')));
  });

  test('honours the 24 hour setting', () {
    expect(fmt(DateTime(2026, 11, 11, 21, 5), h24: true), '21:05');
  });

  test('earlier this year adds the date, older adds the year', () {
    expect(fmt(DateTime(2026, 11, 9, 9, 41)), startsWith('Nov 9, '));
    expect(fmt(DateTime(2025, 12, 31, 9, 41)), startsWith('Dec 31, 2025, '));
  });

  test('messageTimestampOf tolerates objects without a timestamp', () {
    expect(messageTimestampOf(Object()), isNull);
    expect(messageTimestampOf(_Stamped(now)), now);
  });
}

class _Stamped {
  _Stamped(this.timestamp);
  final DateTime timestamp;
}
