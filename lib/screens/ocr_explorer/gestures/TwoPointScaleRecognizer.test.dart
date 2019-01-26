import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodvocabularyapp/screens/ocr_explorer/gestures/TwoPointScaleRecognizer.dart';

main() {
  test('twoPointMoveRecognizer: test1', () async {
    final p1 = TestPointer(1);
    final p2 = TestPointer(2);

    await twoPointMoveRecognizerTestCase(
        Stream.fromIterable([
          p1.down(const Offset(0.0, 0.0)),
          p2.down(const Offset(10.0, 10.0)),
          p1.move(const Offset(1.0, 1.0)),
          p2.move(const Offset(11.0, 11.0)),
          p2.up(),
          p1.up(),
        ]),
        [
          TwoPointEventStart(
              Duration.zero, Offset(0.0, 0.0), Offset(10.0, 10.0)),
          TwoPointEventUpdate(
              Duration.zero, Offset(1.0, 1.0), Offset(10.0, 10.0)),
          TwoPointEventUpdate(
              Duration.zero, Offset(1.0, 1.0), Offset(11.0, 11.0)),
          TwoPointEventEnd(Duration.zero, Offset(1.0, 1.0), Offset(11.0, 11.0)),
        ]);
  });

  test('twoPointMoveRecognizer test2', () async {
    final p1 = TestPointer(1);
    final p2 = TestPointer(2);

    await twoPointMoveRecognizerTestCase(
        Stream.fromIterable([
          p1.down(const Offset(0.0, 0.0)),
          p1.move(const Offset(1.0, 1.0)),
          p2.down(const Offset(10.0, 10.0)),
          p1.move(const Offset(2.0, 2.0)),
          p2.up(),
          p1.up(),
        ]),
        [
          TwoPointEventStart(
              Duration.zero, Offset(0.0, 0.0), Offset(10.0, 10.0)),
          TwoPointEventUpdate(
              Duration.zero, Offset(2.0, 2.0), Offset(10.0, 10.0)),
          TwoPointEventEnd(Duration.zero, Offset(2.0, 2.0), Offset(10.0, 10.0)),
        ]);
  });

  test('twoPointMoveRecognizer test3', () async {
    final p1 = TestPointer(1);
    final p2 = TestPointer(2);
    final p3 = TestPointer(3);

    await twoPointMoveRecognizerTestCase(
        Stream.fromIterable([
          p1.down(const Offset(0.0, 0.0)),
          p2.down(const Offset(10.0, 10.0)),
          p3.down(const Offset(15.0, 15.0)),
          p3.up(),
          p1.move(const Offset(1.0, 1.0)),
          p2.up(),
          p1.up()
        ]),
        []);
  });

  test('scaleRecognizer() test1', () async {
    await scaleRecognizerTestCase(
        Stream.fromIterable([
          TwoPointEventStart(
              Duration.zero, Offset(10.0, 10.0), Offset(20.0, 10.0)),
          TwoPointEventUpdate(
              Duration.zero, Offset(5.0, 10.0), Offset(25.0, 10.0)),
          TwoPointEventEnd(Duration.zero, Offset(0.0, 10.0), Offset(40.0, 49.0))
        ]),
        [
          ScaleEventStart(),
          ScaleEventUpdate(2.0, Offset(0.0, 0.0)),
          ScaleEventEnd(2.0, Offset(0.0, 0.0))
        ]);
  });
}

Future<void> twoPointMoveRecognizerTestCase(stream, expected) async {
  var result = await mapToTwoPointEvents(stream).toList();
  expect(result.join('\n'), equals(expected.join('\n')));
}

Future<void> scaleRecognizerTestCase(stream, expected) async {
  var result = await mapToTwoPointEvents(stream).toList();
  expect(result.join('\n'), equals(expected.join('\n')));
}
