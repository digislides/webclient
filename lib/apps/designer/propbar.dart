import 'package:nuts/nuts.dart';
import 'package:webclient/models/models.dart';
import 'package:fontawesome/fontawesome.dart';

class _Tabs implements Component {
  @override
  String key;

  final StoredReactive<bool> showingItems;

  _Tabs() : showingItems = StoredReactive<bool>(initial: false);

  @override
  View makeView() {
    return HBox(class_: 'rsidebar-tabs', children: [
      TextField(
          class_: 'rsidebar-tab',
          text: FASolid.clipboard_list,
          fontFamily: 'fa5-free',
          onClick: () => showingItems.value = false)
        ..classes.bindBool('selected', showingItems.values.map((v) => !v)),
      TextField(
          class_: 'rsidebar-tab',
          text: FASolid.list,
          fontFamily: 'fa5-free',
          onClick: () => showingItems.value = true)
        ..classes.bindBool('selected', showingItems.values),
    ]);
  }
}

class RightSidebar implements Component {
  @override
  String key;

  final View view;

  RightSidebar(this.view);

  @override
  View makeView() {
    return Box(class_: 'rsidebar', children: [
      _Tabs(),
      Box(class_: 'rsidebar-content', child: view),
    ]);
  }
}
