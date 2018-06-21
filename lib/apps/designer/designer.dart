import 'package:nuts/nuts.dart';
import 'package:webclient/models/models.dart';
import 'package:webclient/components/stage/stage.dart';
import 'package:webclient/components/property/property.dart';
import 'pagelist.dart';
import 'propbar.dart';

Program program;

final selectedPage = new Reactive<Page>()
  ..values.listen((p) {
    selectedItem.value = null;
  });

final selectedItem = StoredReactive<PageItem>();

class TitleBar implements Component {
  @override
  String key;

  String name;

  TitleBar(this.name, {this.key});

  @override
  View makeView() {
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

  @override
  View makeView() {
    return HBox(class_: 'app', children: [
      Box(class_: 'sidebar', children: [
        TitleBar(program.name),
        PageList(program.pages, selectedPage)
      ]),
      Box(class_: 'content', children: [
        VariableView<Page>(selectedPage.value, selectedPage.values,
            (p) => Stage(p)..onSelect.pipeToRx(selectedItem)),
      ]),
      RightSidebar(
          VariableView<PageItem>(selectedItem.value, selectedItem.values, (i) {
        if (i is TextItem) return TextItemProperties(i);
        return Box();
      })),
    ]);
  }
}
