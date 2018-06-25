import 'dart:math';
import 'package:nuts/nuts.dart';

import 'page.dart';

import 'text.dart';
import 'image.dart';
import 'video.dart';

export 'text.dart';
export 'image.dart';
export 'video.dart';

enum PageItemType { text, image, video }

class Fit {
  final int id;

  final String name;

  const Fit._(this.id, this.name);

  static const normal = const Fit._(0, 'Normal');
  static const contain = const Fit._(1, 'Contain');
  static const cover = const Fit._(2, 'Cover');
  static const tile = const Fit._(3, 'Tile');

  static List<Fit> get values => [normal, contain, cover, tile];

  static Fit find(index) {
    if (index is int) {
      if (index < 0 || index > 3) index = 0;
      return values[index];
    }
    return normal;
  }
}

enum Align { left, center, right }

PageItem createItem(int type, Map v) {
  if (type == PageItemType.text.index) return new TextItem()..fromMap(v);
  if (type == PageItemType.image.index) return new ImageItem()..fromMap(v);
  if (type == PageItemType.video.index) return new VideoItem()..fromMap(v);
  // TODO
  return null;
}

abstract class RxPageItem {
  RxValue<String> get name;

  RxValue<int> get width;

  RxValue<int> get height;

  RxValue<int> get left;

  RxValue<int> get top;

  RxValue<String> get bgColor;

  RxValue<Rectangle<int>> get rect;
}

abstract class PageItem {
  String get id;

  RxPageItem get rx;

  PageItemType get type;

  String name;

  int width;

  int height;

  int left;

  int top;

  String bgColor;

  PageItem clone();

  Rectangle<int> get rect;

  void fromMap(Map map);

  Map get toMap;
}

abstract class PageItemMixin implements PageItem {
  String get name => rx.name.value;
  set name(String value) => rx.name.value = value;

  int get width => rx.width.value;
  set width(int value) => rx.width.value = value;

  int get height => rx.height.value;
  set height(int value) => rx.height.value = value;

  int get left => rx.left.value;
  set left(int value) => rx.left.value = value;

  int get top => rx.top.value;
  set top(int value) => rx.top.value = value;

  String get bgColor => rx.bgColor.value;
  set bgColor(String value) => rx.bgColor.value = value;

  Rectangle<int> get rect => new Rectangle(left, top, width, height);
}

abstract class RxPageItemMixin implements RxPageItem {
  final name = RxValue<String>();

  final width = RxValue<int>();

  final height = RxValue<int>();

  final left = RxValue<int>();

  final top = RxValue<int>();

  final bgColor = RxValue<String>();
}
