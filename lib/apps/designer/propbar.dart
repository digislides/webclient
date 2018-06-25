import 'package:nuts/nuts.dart';
import 'package:webclient/models/models.dart';
import 'package:fontawesome/fontawesome.dart';

class _Tabs implements Component {
  @override
  String key;

  final RxValue<bool> showingItems;

  _Tabs() : showingItems = RxValue<bool>(initial: false) {
    view = _makeView();
  }

  View view;

  @override
  View _makeView() {
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

  final View content;

  RightSidebar(this.content) {
    view = _makeView();
  }

  View view;

  @override
  View _makeView() {
    return Box(class_: 'rsidebar', children: [
      _Tabs(),
      Box(class_: 'rsidebar-content', child: content),
    ]);
  }
}
