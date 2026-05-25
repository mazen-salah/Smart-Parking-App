import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking/core/utils/duration_formatter.dart';

void main() {
  group('DurationFormatter', () {
    test('formats zero', () {
      expect(DurationFormatter.format(Duration.zero), '0:00:00');
    });

    test('formats sub-minute durations', () {
      expect(DurationFormatter.format(const Duration(seconds: 7)), '0:00:07');
    });

    test('formats minutes and seconds', () {
      expect(
        DurationFormatter.format(const Duration(minutes: 4, seconds: 9)),
        '0:04:09',
      );
    });

    test('formats hours, minutes, seconds', () {
      expect(
        DurationFormatter.format(
          const Duration(hours: 2, minutes: 30, seconds: 5),
        ),
        '2:30:05',
      );
    });

    test('rolls minutes past 60 into hours', () {
      expect(
        DurationFormatter.format(const Duration(minutes: 125)),
        '2:05:00',
      );
    });
  });
}
