import 'dart:async';
import 'package:nuts/nuts.dart';
import 'package:webclient/models/models.dart';

class PageListItem implements Component {
  Page page;

  final Reactive<Page> selectedPage;

  bool get isSelected => page == selectedPage.value;

  Stream<bool> get _selectionChange =>
      selectedPage.values.map((p) => p == page);

  @override
  final String key;

  PageListItem(this.page, this.selectedPage) : key = page.id {}

  @override
  View makeView() {
    HBox ret;
    ret = HBox(class_: 'slidelist-item', children: [
      TextField(
          text: page.rx.name,
          class_: 'slidelist-label',
          onClick: () => selectedPage.value = page)
    ])
      ..classes.bindBool('selected', _selectionChange)
      ..classes.addIf(isSelected, 'selected');
    return ret;
  }
}

class PageList implements Component {
  @override
  String key;

  final List<Page> pages;

  final Reactive<Page> selectedPage;

  PageList(this.pages, this.selectedPage, {this.key});

  @override
  View makeView() {
    return Box(
        class_: 'slidelist', children: pages.map((page) => PageListItem(page, selectedPage)));
  }
}
