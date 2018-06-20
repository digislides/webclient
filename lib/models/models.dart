import 'dart:math';
import 'package:bson_objectid/bson_objectid.dart';

import 'package:nuts/nuts.dart';

class Player {
  String id;

  String name;
}

class ReactivePage {
  final name = StoredReactive<String>();
  final width = StoredReactive<int>();
  final height = StoredReactive<int>();
  final color = StoredReactive<String>();
  final image = StoredReactive<String>();
  final fit = StoredReactive<ImageFit>();
  final duration = StoredReactive<int>();
  final transition = StoredReactive<int>();
  final transitionDuration = StoredReactive<num>();
  final items = IfList<PageItem>();
}

class Page {
  String id;

  final ReactivePage rx = ReactivePage();

  String get name => rx.name.value;
  set name(String value) => rx.name.value = value;

  int get width => rx.width.value;
  set width(int value) => rx.width.value = value;

  int get height => rx.height.value;
  set height(int value) => rx.height.value = value;

  String get color => rx.color.value;
  set color(String value) => rx.color.value = value;

  String get image => rx.image.value;
  set image(String image) => rx.image.value = image;

  ImageFit get fit => rx.fit.value;
  set fit(ImageFit value) => rx.fit.value = value;

  int get duration => rx.duration.value;
  set duration(int value) => rx.duration.value = value;

  int get transition => rx.transition.value;
  set transition(int value) => rx.transition.value = value;

  num get transitionDuration => rx.transitionDuration.value;
  set transitionDuration(num value) => rx.transitionDuration.value = value;

  IfList<PageItem> get items => rx.items;

  Page({
    this.id,
    String name: 'Page',
    int width: 0,
    int height: 0,
    String color: 'white',
    String image,
    ImageFit fit: ImageFit.cover,
    int duration: 5,
    int transition: 0,
    num transitionDuration: 0,
    Iterable<PageItem> items: const <PageItem>[],
  }) {
    id ??= new ObjectId().toHexString();
    this.name = name;
    this.width = width;
    this.height = height;
    this.color = color;
    this.image = image;
    this.fit = fit;
    this.duration = duration;
    this.transition = transition;
    this.transitionDuration = transitionDuration;
    this.items.addAll(items);
  }

  Page clone() {
    return new Page(
        name: name,
        width: width,
        height: height,
        color: color,
        image: image,
        duration: duration,
        transition: transition,
        transitionDuration: transitionDuration,
        items: items.map((i) => i.clone()).toList());
  }

  void fromMap(Map map) {
    id = map['id'];
    name = map['name'] ?? 'Page';
    color = map['color'] ?? 'white';
    image = map['image'];
    fit = ImageFit.find(map['fit']);
    duration = map['duration'] ?? 0;
    // TODO transition
    // TODO transitionDuration
    items.assignAll(((map['items'] ?? <Map>[]) as List)
        .map((m) {
          if (m['type'] is int) {
            return createItem(m['type'], m);
          }
          return null;
        })
        .where((v) => v is PageItem)
        .toList()
        .cast<PageItem>());
  }

  Map get toMap => {
        'id': id,
        'name': name,
        'color': color,
        'image': image,
        'fit': fit.id,
        'duration': duration,
        // TODO transition
        // TODO transitionDuration
        'items': items.map((i) => i.toMap).toList(),
      };
}

class Program {
  String id;

  String name;

  int _width = 0;

  int _height = 0;

  List<Page> pages;

  Program(
      {this.id,
      this.name: 'Program',
      int width: 0,
      int height: 0,
      this.pages}) {
    id ??= new ObjectId().toHexString();
    pages ??= <Page>[];
    this.width = width;
    this.height = height;
  }

  int get width => _width;

  set width(int v) {
    _width = v;
    pages.forEach((Page p) {
      p.width = _width;
    });
  }

  int get height => _height;

  set height(int v) {
    _height = v;
    pages.forEach((Page p) {
      p.height = _height;
    });
  }

  void removePagesById(Set<String> ids) {
    pages.removeWhere((p) => ids.contains(p.id));
  }

  void duplicatePage(String pageId) {
    final page = pages.firstWhere((p) => p.id == pageId, orElse: () => null);
    if (page == null) return;
    Page dupPage = page.clone();
    // Add new page to pages
    int pos = pages.indexOf(page);
    pages.insert(pos + 1, dupPage);
  }

  void movePageTo(String pageId, int newPos) {
    final page = pages.firstWhere((p) => p.id == pageId, orElse: () => null);
    pages.remove(page);
    if (newPos < pages.length) {
      pages.insert(newPos, page);
    } else {
      pages.add(page);
    }
  }

  void newPage(
          {String id,
          String name: 'New page',
          int width,
          int height,
          String color: 'white',
          String image,
          List<PageItem> items}) =>
      pages.add(new Page(
          id: id,
          name: name,
          width: width ?? this.width,
          height: height ?? this.height,
          color: color,
          image: image,
          items: items));

  void fromMap(Map map) {
    id = map['_id'];
    name = map['name'] ?? 'Program';
    width = map['width'] ?? 0;
    height = map['height'] ?? 0;
    pages = ((map['pages'] ?? <Map>[]) as List)
        .where((p) => p is Map)
        .map((m) => new Page(width: width, height: height)..fromMap(m))
        .toList()
        .cast<Page>();
  }

  Map get toMap => {
        '_id': id,
        'name': name,
        'width': width,
        'height': height,
        'pages': pages.map((p) => p.toMap).toList(),
      };
}

enum PageItemType { text, image, video }

abstract class RxPageItem {
  Reactive<String> get name;

  Reactive<int> get width;

  Reactive<int> get height;

  Reactive<int> get left;

  Reactive<int> get top;

  Reactive<String> get bgColor;
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
  final name = Reactive<String>();

  final width = Reactive<int>();

  final height = Reactive<int>();

  final left = Reactive<int>();

  final top = Reactive<int>();

  final bgColor = StoredReactive<String>();
}

enum Align { left, center, right }

PageItem createItem(int type, Map v) {
  if (type == PageItemType.text.index) return new TextItem()..fromMap(v);
  // TODO if (type == PageItemType.image.index) return new ImageItem()..fromMap(v);
  // TODO if (type == PageItemType.video.index) return new VideoItem()..fromMap(v);
  return null;
}

class RxFontProperties {
  final size = StoredReactive<int>();

  final align = StoredReactive<Align>();

  final family = StoredReactive<String>();

  final color = StoredReactive<String>();

  final bold = StoredReactive<bool>();

  final italic = StoredReactive<bool>();

  final underline = StoredReactive<bool>();
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

class RxTextItem extends Object with RxPageItemMixin implements RxPageItem {
  final text = StoredReactive<String>();
}

class TextItem extends Object with PageItemMixin implements PageItem {
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

class ImageFit {
  final int id;

  final String bgSize;

  final String repeat;

  const ImageFit._(this.id, this.bgSize, this.repeat);

  static const none = const ImageFit._(0, 'auto', 'no-repeat');
  static const contain = const ImageFit._(1, 'contain', 'no-repeat');
  static const cover = const ImageFit._(2, 'cover', 'no-repeat');
  static const tile = const ImageFit._(3, 'auto', 'repeat');

  static List<ImageFit> get values => [none, contain, cover, tile];

  static ImageFit find(index) {
    if (index is int) {
      if (index < 0 || index > 3) index = 0;
      return values[index];
    }
    return none;
  }
}

/*
class ImageItem extends Object with PageItemMixin implements PageItem {
  String id;

  String name;

  int width;

  int height;

  int left;

  int top;

  String url;

  ImageFit fit;

  ImageItem(
      {this.id,
      this.name: 'Image',
      this.width: 0,
      this.height: 0,
      this.left: 0,
      this.top: 0,
      this.url,
      this.fit: ImageFit.cover}) {
    id ??= new ObjectId().toHexString();
  }

  ImageItem clone() {
    return new ImageItem(
        name: name,
        width: width,
        height: height,
        left: left,
        top: top,
        url: url);
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
        'url': url,
        'fit': fit.id,
      };

  @override
  void fromMap(Map map) {
    id = map['id'];
    name = map['name'] ?? 'Text';
    width = map['width'] ?? 0;
    height = map['height'] ?? 0;
    left = map['left'] ?? 0;
    top = map['top'] ?? 0;
    url = map['url'];
    fit = ImageFit.find(map['fit']);
  }

  @override
  final PageItemType type = PageItemType.image;
}

class VideoItem extends Object with PageItemMixin implements PageItem {
  String id;

  String name;

  int width;

  int height;

  int left;

  int top;

  String url;

  VideoItem(
      {this.id,
      this.name: 'Video',
      this.width: 0,
      this.height: 0,
      this.left: 0,
      this.top: 0,
      this.url}) {
    id ??= new ObjectId().toHexString();
  }

  VideoItem clone() {
    return new VideoItem(
        name: name,
        width: width,
        height: height,
        left: left,
        top: top,
        url: url);
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
        'url': url,
      };

  @override
  void fromMap(Map map) {
    id = map['id'];
    name = map['name'] ?? 'Text';
    width = map['width'] ?? 0;
    height = map['height'] ?? 0;
    left = map['left'] ?? 0;
    top = map['top'] ?? 0;
    url = map['url'];
  }

  @override
  final PageItemType type = PageItemType.video;
}
*/
