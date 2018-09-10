import 'package:nuts/nuts.dart';
import 'package:webclient/models/models.dart';
import 'package:fontawesome/fontawesome.dart';

import 'property.dart';

class ImageItemProperties implements Component {
  @override
  final String key;

  final ImageItem item;

  ImageItemProperties(this.item, {this.key}) {
    view = _makeView();
  }

  View view;

  View _makeView() {
    return Box(children: [
      ImageProperty(FASolid.image, item.rx.url),
      PositionProperty(item),
      SizeProperty(item),
      FitProperty(item.rx.fit),
      ColorProperty(FASolid.chess_board, item.rx.bgColor),
    ]);
  }
}

class ImageProperty implements Component {
  final String icon;
  final RxValue<String> property;

  @override
  final String key;

  ImageProperty(this.icon, this.property, {this.key}) {
    view = _makeView();
  }

  View view;

  View _makeView() {
    return Box(classes: [
      'ech-field',
    ], children: [
      HBox(
        classes: ['ech-superdropdownedit', 'ech-imageedit'],
        children: [
          Tin(
              class_: 'ech-image-display-tiny',
              backgroundImage: property.map((v) => v ?? '').map((v) =>
                  v.isNotEmpty ? 'url($v)' : '/static/image/no_image.svg')),
          TextEdit(
              value: property,
              placeholder: 'Image URL',
              width: FlexSize(1.0),
              onCommit: (ValueCommitEvent<String> v) {
                property.value = v.value;
              })
            ..classes.add('textinput')
            ..classes.remove('textinput'),
          TextField(
              text: FASolid.eye,
              fontFamily: 'fa5-free',
              class_: 'ech-field-action',
              onClick: () {
                // TODO
              }),
        ],
      ),
    ]);
  }
}
