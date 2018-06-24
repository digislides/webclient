import 'dart:math';
import 'package:bson_objectid/bson_objectid.dart';
import 'package:nuts/nuts.dart';

import 'models.dart';
import 'item.dart';

export 'item.dart';

class ReactivePage {
  final name = StoredReactive<String>();
  final width = StoredReactive<int>();
  final height = StoredReactive<int>();
  final color = StoredReactive<String>();
  final image = StoredReactive<String>();
  final fit = StoredReactive<Fit>();
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

  Fit get fit => rx.fit.value;
  set fit(Fit value) => rx.fit.value = value;

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
    Fit fit: Fit.cover,
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
    fit = Fit.find(map['fit']);
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