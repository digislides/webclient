import 'package:nuts/nuts.dart';
import 'package:webclient/models/models.dart';
import 'package:fontawesome/fontawesome.dart';

import 'property.dart';

class TextItemProperties implements Component {
  @override
  final String key;

  final TextItem item;

  TextItemProperties(this.item, {this.key}) {
    view = _makeView();
  }

  View view;

  View _makeView() {
    return Box(children: [
      TextProperty(item),
      PositionProperty(item),
      SizeProperty(item),
      ColorProperty(FASolid.chess_board, item.rx.bgColor),
      ColorProperty(FASolid.font, item.font.rx.color),
      HBox(
          class_: 'ech-field',
          child: IconEdit<int>(
            IntEdit(
                placeholder: 'Font size',
                value: item.font.rx.size,
                onCommit: (ValueCommitEvent<int> v) =>
                    item.font.size = v.value),
            icon: FASolid.text_width,
            width: FlexSize(1.0),
          ))
    ]);
  }
}

class TextProperty implements Component {
  final String key;

  final TextItem item;

  View view;

  TextProperty(this.item, {this.key}) {
    view = _makeView();
  }

  View _makeView() {
    return Tin(class_: 'ech-field', children: [
      MultilineEdit(
          class_: 'ech-multilineedit',
          value: item.rx.text,
          placeholder: 'Text',
          onCommit: (ValueCommitEvent<String> v) {
            item.text = v.value;
          }),
    ]);
  }
}
