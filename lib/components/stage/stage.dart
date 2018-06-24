import 'dart:math';
import 'dart:async';
import 'package:nuts/nuts.dart';
import 'package:webclient/models/models.dart';
import 'anchor.dart';

class Stage implements Component {
  @override
  String key;

  final Page page;

  final Reactive<PageItem> selectedItem;

  Stage(this.page, this.selectedItem, {this.key}) {
    view = _makeView();
  }

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

  final state = StoredReactive<int>(initial: 0);

  Stream<bool> get _isMoving => state.map((v) => v != 0);

  dynamic _start;

  View view;

  View _makeView() => Tin(
        class_: 'stage-viewport',
        child: Relative(
          class_: 'stage-canvas',
          minWidth: _canvasWidths,
          minHeight: _canvasHeights,
          children: [
            Absolute(
              class_: 'stage',
              width: _widths,
              height: _heights,
              backgroundColor: page.rx.color,
              children: RxChildList(
                  page.items,
                  (p) => StageItem(p)
                    ..onSelect.on((i) {
                      selectedItem.value = i;
                    })),
            )..classes.bindBool('inactive', _isMoving),
            Absolute(
                class_: 'stage-anchors',
                width: _widths,
                height: _heights,
                child: VariableView<PageItem>.rx(selectedItem, (i) {
                  if (i == null) return Box();
                  return Anchors(i, _isMoving)
                    ..onMoveStart.on(() {
                      if (selectedItem.value == null) return;
                      state.value = 1;
                      _start = selectedItem.value.rect.topLeft;
                    })
                    ..onHResizeStart.on(() {
                      if (selectedItem.value == null) return;
                      state.value = 2;
                      _start = selectedItem.value.width;
                    })
                    ..onVResizeStart.on(() {
                      if (selectedItem.value == null) return;
                      state.value = 3;
                      _start = selectedItem.value.height;
                    });
                })),
          ],
        )
          ..onMouseDown.listen((ClickEvent e) {
            _clickStart = e.time;
          })
          ..onMouseUp.on((ClickEvent e) {
            state.value = 0;
            _start = null;
            if (_clickStart != null) {
              var timeDiff = DateTime.now().difference(_clickStart);
              if (timeDiff < Duration(milliseconds: 100))
                selectedItem.value = null;
            }
            _clickStart = null;
          })
          ..onMouseMove.on((ClickEvent e) {
            if (e.button != 1 || selectedItem.value == null) return;
            if (state.value == 1) {
              selectedItem.value.left = e.offset.x.toInt() - 150;
              selectedItem.value.top = e.offset.y.toInt() - 150;
            } else if (state.value == 2) {
              int width = e.offset.x.toInt() - 150 - selectedItem.value.left;
              if (width < 0) width = 0;
              selectedItem.value.width = width;
            } else if (state.value == 3) {
              int height = e.offset.y.toInt() - 150 - selectedItem.value.top;
              if (height < 0) height = 0;
              selectedItem.value.height = height;
            }
          }), // TODO mouse out,
      );
  DateTime _clickStart;
}

class StageItem implements Component {
  String key;
  final PageItem item;

  final onSelect = StreamBackedEmitter<PageItem>();

  StageItem(this.item, {onClick}) {
    if (onClick != null) this.onSelect.on(onClick);
    view = _makeView();
  }

  View view;

  View _makeView() {
    if (item is TextItem) {
      TextItem item = this.item;
      return TextField(
          classes: ['stage-item', 'stage-item-text'],
          text: item.rx.text,
          width: item.rx.width.map((w) => FixedDistance(w)),
          height: item.rx.height.map((w) => FixedDistance(w)),
          left: item.rx.left.map((w) => FixedDistance(w)),
          top: item.rx.top.map((w) => FixedDistance(w)),
          backgroundColor: item.rx.bgColor,
          color: item.font.rx.color)
        ..onClick.on((_) {
          onSelect.emit(item);
        });
    } else if (item is ImageItem) {
      ImageItem item = this.item;
      return Tin(
          classes: ['stage-item', 'stage-item-image'],
          backgroundImage: item.rx.url.map((v) => v ?? '').map(
              (v) => v.isNotEmpty ? 'url($v)' : '/static/image/no_image.svg'),
          width: item.rx.width.map((w) => FixedDistance(w)),
          height: item.rx.height.map((w) => FixedDistance(w)),
          left: item.rx.left.map((w) => FixedDistance(w)),
          top: item.rx.top.map((w) => FixedDistance(w)),
          backgroundColor: item.rx.bgColor)
        ..classes.bindOneOf(
            ['fit-normal', 'fit-contains', 'fit-cover', 'fit-tile'],
            item.rx.fit.map((f) => f.id),
            item.rx.fit.value.id)
        ..onClick.on((_) {
          onSelect.emit(item);
        });
    } else if (item is VideoItem) {
      VideoItem item = this.item;
      return Tin(
          classes: ['stage-item', 'stage-item-video'],
          // TODO image
          width: item.rx.width.map((w) => FixedDistance(w)),
          height: item.rx.height.map((w) => FixedDistance(w)),
          left: item.rx.left.map((w) => FixedDistance(w)),
          top: item.rx.top.map((w) => FixedDistance(w)),
          backgroundColor: item.rx.bgColor)
        ..classes.bindOneOf(
            ['fit-normal', 'fit-contains', 'fit-cover', 'fit-tile'],
            item.rx.fit.map((f) => f.id),
            item.rx.fit.value.id)
        ..onClick.on((_) {
          onSelect.emit(item);
        });
    }
    // TODO
    throw new Exception('Unknown item!');
  }
}
