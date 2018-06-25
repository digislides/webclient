import 'dart:math';
import 'package:bson_objectid/bson_objectid.dart';
import 'package:nuts/nuts.dart';

import 'item.dart';

class RxFontProperties {
  final size = RxValue<int>();

  final align = RxValue<Align>();

  final family = RxValue<String>();

  final color = RxValue<String>();

  final bold = RxValue<bool>();

  final italic = RxValue<bool>();

  final underline = RxValue<bool>();
}

class FontProperties {
  final rx = RxFontProperties();

  /// Size of the font
  int get size => rx.size.value;
  set size(int value) => rx.size.value = value;

  Align get align => rx.align.value;
  set align(Align value) => rx.align.value;

  String get family => rx.family.value;
  set family(String value) => rx.family.value = value;

  String get color => rx.color.value;
  set color(String value) => rx.color.value = value;

  bool get bold => rx.bold.value;
  set bold(bool value) => rx.bold.value = value;

  bool get italic => rx.italic.value;
  set italic(bool value) => rx.italic.value = value;

  bool get underline => rx.underline.value;
  set underline(bool value) => rx.underline.value = value;

  // bool lineThrough;

  FontProperties({
    int size: 16,
    Align align: Align.left,
    String family,
    String color: 'black',
    bool bold: false,
    bool italic: false,
    bool underline: false,
    // this.lineThrough: false
  }) {
    this.size = size;
    this.align = align;
    this.family = family;
    this.color = color;
    this.bold = bold;
    this.italic = italic;
    this.underline = underline;
  }

  FontProperties clone() => new FontProperties()..fromMap(toMap);

  Map get toMap => {
    'size': size,
    'align': align.index,
    'family': family,
    'color': color,
    'bold': bold,
    'italic': italic,
    'underline': underline,
    // 'lineThrough': lineThrough,
  };

  void fromMap(Map map) {
    size = map['size'] ?? 16;
    align = Align.values[map['align'] ?? 0];
    family = map['family'];
    color = map['color'] ?? 'black';
    bold = map['bold'] ?? false;
    italic = map['italic'] ?? false;
    underline = map['underline'] ?? false;
    // lineThrough = map['lineThrough'] ?? false;
  }
}

abstract class TextualItem implements PageItem {
  FontProperties get font;
}

class RxTextItem extends Object with RxPageItemMixin implements RxPageItem {
  final text = RxValue<String>();
  final rect = RxValue<Rectangle<int>>();
}

class TextItem extends Object
    with PageItemMixin
    implements PageItem, TextualItem {
  String id;

  final RxTextItem rx = RxTextItem();

  String get text => rx.text.value;
  set text(String value) => rx.text.value = value;

  final FontProperties font;

  TextItem(
      {this.id,
        String name: 'Text',
        int width: 0,
        int height: 0,
        int left: 0,
        int top: 0,
        String bgColor: 'transparent',
        String text: 'Text',
        FontProperties font})
      : font = font ?? FontProperties() {
    id ??= new ObjectId().toHexString();
    this.name = name;
    this.width = width;
    this.height = height;
    this.left = left;
    this.top = top;
    this.text = text;
    this.bgColor = bgColor;
    rx.left.listen((_) => rx.rect.value = rect);
    rx.top.listen((_) => rx.rect.value = rect);
    rx.width.listen((_) => rx.rect.value = rect);
    rx.height.listen((_) => rx.rect.value = rect);
  }

  TextItem clone() {
    return new TextItem(
      name: name,
      width: width,
      height: height,
      left: left,
      top: top,
      text: text,
      /* TODO font: font.clone()*/
    );
  }

  @override
  Map get toMap => {
    'id': id,
    'type': type.index,
    'name': name,
    'width': width,
    'height': height,
    'left': left,
    'top': top,
    'text': text,
    // TODO 'font': font.toMap,
  };

  @override
  void fromMap(Map map) {
    id = map['id'];
    name = map['name'] ?? 'Text';
    width = map['width'] ?? 0;
    height = map['height'] ?? 0;
    left = map['left'] ?? 0;
    top = map['top'] ?? 0;
    text = map['text'] ?? '';
    // TODO font = new FontProperties()..fromMap(map['font'] ?? {});
  }

  @override
  final PageItemType type = PageItemType.text;
}