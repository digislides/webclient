import 'dart:math';
import 'package:bson_objectid/bson_objectid.dart';
import 'package:nuts/nuts.dart';

import 'page.dart';

export 'page.dart';

class Player {
  String id;

  String name;
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