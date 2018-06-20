import 'dart:async';
import 'package:nuts/nuts.dart';
import 'package:webclient/models/models.dart';

class Stage implements Component {
  @override
  String key;

  final Page page;

  Stage(this.page, {this.key});

  final resizing = StoredReactive<bool>(initial: false);

  final moving = StoredReactive<bool>(initial: false);

  Stream<Distance> get _canvasWidths =>
      page.rx.width.map((int v) => FixedDistance(v + 300));

  Stream<Distance> get _canvasHeights =>
      page.rx.height.map((int v) => FixedDistance(v + 300));

  Stream<Distance> get _widths =>
      page.rx.width.map((int v) => FixedDistance(v));

  Stream<Distance> get _heights =>
      page.rx.height.map((int v) => FixedDistance(v));

  @override
  View makeView() => Box(
        class_: 'stage-viewport',
        child: Box(
          class_: 'stage-canvas',
          width: _canvasWidths,
          height: _canvasHeights,
          child: Box(
            class_: 'stage',
            width: _widths,
            height: _heights,
            backgroundColor: page.rx.color,
            children: RxChildList(page.items, (p) => StageItem(p)),
          ),
        ),
      );
}

class StageItem implements Component {
  String key;
  final PageItem item;

  StageItem(this.item);

  @override
  View makeView() {
    if (item is TextItem) {
      TextItem item = this.item;
      return TextField(
          class_: 'stage-item',
          text: item.rx.text,
          width: item.rx.width.map((w) => FixedDistance(w)),
          height: item.rx.height.map((w) => FixedDistance(w)),
          left: item.rx.left.map((w) => FixedDistance(w)),
          top: item.rx.top.map((w) => FixedDistance(w)),
          backgroundColor: item.rx.bgColor,
          color: item.font.rx.color);
    }
    throw new Exception('Unknown item!');
  }
}
