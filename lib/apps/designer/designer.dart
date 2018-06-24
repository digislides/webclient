import 'package:nuts/nuts.dart';
import 'package:bson_objectid/bson_objectid.dart';
import 'package:webclient/models/models.dart';
import 'package:webclient/components/stage/stage.dart';
import 'package:webclient/components/property/property.dart';
import 'package:webclient/components/adder/adder.dart';
import 'pagelist.dart';
import 'propbar.dart';

Program program;

final selectedPage = new StoredReactive<Page>()
  ..values.listen((p) {
    if (selectedItem.value != null) // TODO why is this necessary
      selectedItem.value = null;
  });

final selectedItem = StoredReactive<PageItem>();

class TitleBar implements Component {
  @override
  String key;

  String name;

  TitleBar(this.name, {this.key}) {
    view = _makeView();
  }

  View view;

  View _makeView() {
    return Box(class_: 'titlebar', children: [
      HBox(
          class_: 'title-holder',
          children: [TextField(text: name, class_: 'title')]),
    ]);
  }
}

class Designer implements Component {
  @override
  String key;

  Designer() {
    view = _makeView();
  }

  View view;

  View _makeView() {
    return HBox(class_: 'app', children: [
      Box(class_: 'sidebar', children: [
        TitleBar(program.name),
        PageList(program.pages, selectedPage)
      ]),
      Box(class_: 'content', children: [
        VariableView<Page>.rx(selectedPage, (p) => Stage(p, selectedItem)),
      ]),
      RightSidebar(VariableView<PageItem>.rx(selectedItem, (i) {
        if (i is TextItem) return TextItemProperties(i);
        if (i is ImageItem) return ImageItemProperties(i);
        return Box();
      })),
      Adder()
        ..onAction.listen((String value) {
          if (value == 'add-text') {
            if (selectedPage.value != null) {
              var nI = TextItem(id: ObjectId().toHexString());
              selectedPage.value.items.add(nI);
              selectedItem.value = nI;
            }
          } else if (value == 'add-image') {
            if (selectedPage.value != null) {
              var nI = ImageItem(id: ObjectId().toHexString());
              selectedPage.value.items.add(nI);
              selectedItem.value = nI;
            }
          } else if (value == 'add-video') {
            if (selectedPage.value != null) {
              var nI = VideoItem(id: ObjectId().toHexString());
              selectedPage.value.items.add(nI);
              selectedItem.value = nI;
            }
          } else if (value == 'add-clock') {
            // TODO
          } else if (value == 'add-sun') {
            // TODO
          }
        }),
    ]);
  }
}
