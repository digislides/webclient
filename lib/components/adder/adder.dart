import 'dart:async';
import 'package:nuts/nuts.dart';
import 'package:webclient/models/models.dart';
import 'package:fontawesome/fontawesome.dart';

class Adder implements Component {
  @override
  String key;

  @override
  View view;

  final onAction = StreamBackedEmitter<String>();

  Adder({this.key}) {
    view = _makeView();
  }

  View _makeView() {
    return HBox(class_: 'adder', children: [
      TextField(
          class_: 'item',
          text: FASolid.i_cursor,
          fontFamily: 'fa5-free',
          onClick: () => onAction.emitOne('add-text')),
      TextField(
          class_: 'item',
          text: FASolid.image,
          fontFamily: 'fa5-free',
          onClick: () => onAction.emitOne('add-image')),
      TextField(
          class_: 'item',
          text: FASolid.video,
          fontFamily: 'fa5-free',
          onClick: () => onAction.emitOne('add-video')),
      TextField(
          class_: 'item',
          text: FASolid.clock,
          fontFamily: 'fa5-free',
          onClick: () => onAction.emitOne('add-clock')),
      TextField(
          class_: 'item',
          text: FASolid.sun,
          fontFamily: 'fa5-free',
          onClick: () => onAction.emitOne('add-sun')),
    ]);
  }
}
