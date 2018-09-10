import 'dart:math';
import 'package:bson_objectid/bson_objectid.dart';
import 'package:nuts/nuts.dart';

import 'item.dart';

class RxVideoItem extends Object with RxPageItemMixin implements RxPageItem {
  final url = RxValue<String>();
  final fit = RxValue<Fit>();
  final rect = RxValue<Rectangle<int>>();
}

class VideoItem extends Object with PageItemMixin implements PageItem {
  String id;

  final RxVideoItem rx = RxVideoItem();

  String get url => rx.url.value;
  set url(String value) => rx.url.value = value;

  Fit get fit => rx.fit.value;
  set fit(Fit value) => rx.fit.value = value;

  VideoItem(
      {this.id,
      String name: 'Image',
      int width: 0,
      int height: 0,
      int left: 0,
      int top: 0,
      String bgColor: 'transparent',
      String url,
      Fit fit: Fit.cover}) {
    id ??= new ObjectId().toHexString();
    this.name = name;
    this.width = width;
    this.height = height;
    this.left = left;
    this.top = top;
    this.bgColor = bgColor;
    this.url = url;
    this.fit = fit;
    rx.left.listen((_) => rx.rect.value = rect);
    rx.top.listen((_) => rx.rect.value = rect);
    rx.width.listen((_) => rx.rect.value = rect);
    rx.height.listen((_) => rx.rect.value = rect);
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
