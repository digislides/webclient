import 'package:nuts/nuts.dart';
import 'package:webclient/models/models.dart';
import 'package:webclient/components/stage/stage.dart';
import 'pagelist.dart';
import 'propbar.dart';

class RxProperty {
  const RxProperty();
}

Program program;

final selectedPage = new Reactive<Page>();

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
        VariableView<Page>(
            selectedPage.value, selectedPage.values, (p) => Stage(p)),
      ]),
      RightSidebar(),
    ]);
  }
}
