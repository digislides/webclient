import 'dart:async';
import 'dart:math';
import 'package:nuts/nuts.dart';
import 'package:webclient/models/models.dart';

class Anchors implements Component {
  @override
  final String key;

  final PageItem item;

  final onMoveStart = StreamBackedEmitter<ClickEvent>();

  final onVResizeStart = StreamBackedEmitter<ClickEvent>();

  final onHResizeStart = StreamBackedEmitter<ClickEvent>();

  final Stream<bool> isMoving;

  Anchors(this.item, this.isMoving, {this.key}) {
    view = _makeView();
  }

  View view;

  @override
  View _makeView() {
    return Relative(
        class_: 'anchors-holder',
        children: [
          Absolute(class_: 'mover')..onMouseDown.pipeTo(onMoveStart),
          Absolute(
              classes: ['resizer', 'resizer-e'],
              left: item.rx.width.map((w) => FixedDistance(w - 4)),
              top: item.rx.height.map((h) => FixedDistance((h / 2) - 8)))
            ..onMouseDown.pipeTo(onHResizeStart),
          Absolute(
              classes: ['resizer', 'resizer-s'],
              left: item.rx.width.map((w) => FixedDistance((w / 2) - 8)),
              top: item.rx.height.map((h) => FixedDistance(h - 4)))
            ..onMouseDown.pipeTo(onVResizeStart),
        ],
        left: item.rx.left.map((l) => FixedDistance(l)),
        top: item.rx.top.map((t) => FixedDistance(t)),
        width: item.rx.width.map((w) => FixedDistance(w)),
        height: item.rx.height.map((h) => FixedDistance(h)))
      ..classes.bindBool('inactive', isMoving);
  }
}
