import 'dart:async';
import 'package:nuts/nuts.dart';
import 'package:webclient/models/models.dart';
import 'package:fontawesome/fontawesome.dart';

class TextItemProperties implements Component {
  @override
  String key;

  final TextItem item;

  TextItemProperties(this.item);

  @override
  View makeView() {
    return Box(children: [
      PositionProperty(item.rx.left, item.rx.top),
    ]);
  }
}

class PositionProperty implements Component {
  @override
  String key;

  final Reactive<int> left;

  final Reactive<int> top;

  PositionProperty(this.left, this.top, {this.key});

  @override
  View makeView() {
    return HBox(class_: 'ech-prop-position', children: [
      TextField(text: FASolid.expand),
      TextEdit(value: left),
      TextField(text: ' x '),
      TextEdit(value: top),
    ]);
  }
}
