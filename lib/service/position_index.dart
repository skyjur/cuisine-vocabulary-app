import 'dart:ui';

class PositionIndex<T> {
  // z-curve sorted points
  // final List<Offset> points = [];
  // final List<T> objs = [];
  final List<PositionedObj<T>> _all;

  PositionIndex(Iterable<PositionedObj<T>> all) : _all = all.toList();

  // void add(Offset pos, T obj) {
  // var i = 0;
  // while (i < points.length) {
  //   if (pos.distanceSquared < points[i].distanceSquared) {
  //     break;
  //   }
  // }
  // points.replaceRange(i, i, [pos]);
  // objs.replaceRange(i, i, [obj]);
  // _all.add(PositionedObj(pos, obj));
  // }

  List<T> findInRadius(Offset pos, double radius) {
    // var l = 0;
    // var r = points.length - 1;
    // while (r - l > 1) {
    //   var m = (r + l) ~/ 2;
    //   if(points[m].distanceSquared > pos.distanceSquared) {

    //   }
    // }
    return _all
        .where((x) => x.isInRadius(pos, radius))
        .map((x) => x.obj)
        .toList();
  }
}

class PositionedObj<T> {
  PositionedObj(this.obj, {this.top, this.right, this.bottom, this.left});
  final T obj;
  final double left;
  final double bottom;
  final double right;
  final double top;

  bool isInRadius(Offset pos, double radius) {
    return left < (pos.dx + radius) &&
        right > (pos.dx - radius) &&
        top < (pos.dy + radius) &&
        bottom > (pos.dy - radius);
  }
}
