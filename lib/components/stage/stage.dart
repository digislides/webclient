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
      page.reactive.width.values.map((int v) => FixedSize(v + 300));

  Stream<Size> get _canvasHeights =>
      page.reactive.height.values.map((int v) => FixedSize(v + 300));

  Stream<Size> get _widths =>
      page.reactive.width.values.map((int v) => FixedSize(v));

  Stream<Size> get _heights =>
      page.reactive.height.values.map((int v) => FixedSize(v));

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
            backgroundColor: page.reactive.color,
          ),
        ),
      );
}
