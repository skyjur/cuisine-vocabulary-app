import 'dart:ui';

import "package:test/test.dart";
import 'package:twfoodtranslations/utils/position_index.dart';

void main() {
  test("Find in radius", () {
    var idx = PositionIndex<int>([
      PositionedObj(1, top: 10.0, right: 20.0, bottom: 20.0, left: 10.0),
    ]);
    expect(idx.findInRadius(Offset(15.0, 15.0), 15.0), equals([1]));
    expect(idx.findInRadius(Offset(15.0, 15.0), 30.0), equals([1]));
    expect(idx.findInRadius(Offset(30.0, 30.0), 15.0), equals([1]));
    expect(idx.findInRadius(Offset(30.0, 30.0), 5.0), equals([]));
  });
}
