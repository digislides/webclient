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

  Stream<Size> get _canvasWidths =>
      page.rx.width.map((int v) => FixedSize(v + 300));

  Stream<Size> get _canvasHeights =>
      page.rx.height.map((int v) => FixedSize(v + 300));

  Stream<Size> get _widths => page.rx.width.map((int v) => FixedSize(v));

  Stream<Size> get _heights => page.rx.height.map((int v) => FixedSize(v));

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
  View makeView() => Box(
      class_: 'item',
      width: item.rx.width.map((w) => FixedSize(w)),
      height: item.rx.height.map((w) => FixedSize(w)));
}
