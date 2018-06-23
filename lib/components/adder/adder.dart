import 'dart:async';
import 'package:nuts/nuts.dart';
import 'package:webclient/models/models.dart';
import 'package:fontawesome/fontawesome.dart';

class Adder implements Component {
  @override
  String key;

  @override
  View view;

  Adder({this.key}) {
    view = _makeView();
  }

  View _makeView() {
    return HBox(class_: 'adder', children: [
      TextField(class_: 'item', text: FASolid.i_cursor, fontFamily: 'fa5-free'),
      TextField(class_: 'item', text: FASolid.image, fontFamily: 'fa5-free'),
      TextField(class_: 'item', text: FASolid.video, fontFamily: 'fa5-free'),
      TextField(class_: 'item', text: FASolid.clock, fontFamily: 'fa5-free'),
      TextField(class_: 'item', text: FASolid.sun, fontFamily: 'fa5-free'),
    ]);
  }
}
