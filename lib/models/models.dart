import 'dart:math';
import 'package:bson_objectid/bson_objectid.dart';

class Player {
  String id;

  String name;
}

class Page {
  String id;

  String name;

  int width;

  int height;

  String color;

  String image;

  ImageFit fit;

  int duration;

  int transition;

  num transitionDuration;

  List<PageItem> items;

  Page(
      {this.id,
      this.name: 'Page',
      this.width: 0,
      this.height: 0,
      this.color: 'white',
      this.image,
      this.duration: 5,
      this.transition: 0,
      this.transitionDuration: 0,
      this.items,
      this.fit: ImageFit.cover}) {
    id ??= new ObjectId().toHexString();
    items ??= new List<PageItem>();
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
    items = ((map['items'] ?? <Map>[]) as List)
        .map((m) {
          if (m['type'] is int) {
            return createItem(m['type'], m);
          }
          return null;
        })
        .where((v) => v is PageItem)
        .toList()
        .cast<PageItem>();
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

abstract class PageItem {
  String get id;

  PageItemType get type;

  String name;

  int width;

  int height;

  int left;

  int top;

  PageItem clone();

  Rectangle<int> get rect;

  void fromMap(Map map);

  Map get toMap;
}

abstract class PageItemMixin implements PageItem {
  Rectangle<int> get rect => new Rectangle(left, top, width, height);
}

enum Align { left, center, right }

class FontProperties {
  /// Size of the font
  int size;

  Align align;

  String family;

  String color;

  bool bold;

  bool italic;

  bool underline;

  // bool lineThrough;

  FontProperties({
    this.size: 16,
    this.align: Align.left,
    this.family,
    this.color: 'black',
    this.bold: false,
    this.italic: false,
    this.underline: false,
    // this.lineThrough: false
  });

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

PageItem createItem(int type, Map v) {
  if (type == PageItemType.text.index) return new TextItem()..fromMap(v);
  if (type == PageItemType.image.index) return new ImageItem()..fromMap(v);
  if (type == PageItemType.video.index) return new VideoItem()..fromMap(v);
  return null;
}

class TextItem extends Object with PageItemMixin implements PageItem {
  String id;

  String name;

  int width;

  int height;

  int left;

  int top;

  String text;

  FontProperties font;

  TextItem(
      {this.id,
      this.name: 'Text',
      this.width: 0,
      this.height: 0,
      this.left: 0,
      this.top: 0,
      this.text: 'Text',
      this.font}) {
    id ??= new ObjectId().toHexString();
    font ??= new FontProperties();
  }

  TextItem clone() {
    return new TextItem(
        name: name,
        width: width,
        height: height,
        left: left,
        top: top,
        text: text,
        font: font.clone());
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
        'font': font.toMap,
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
    font = new FontProperties()..fromMap(map['font'] ?? {});
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
