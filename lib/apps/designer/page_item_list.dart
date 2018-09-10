import 'dart:async';
import 'package:nuts/nuts.dart';
import 'package:webclient/models/models.dart';

class PageItemListItem implements Component {
  final PageItem item;

  final RxValue<PageItem> selectedItem;

  bool get isSelected => item == selectedItem.value;

  Stream<bool> get _selectionChange =>
      selectedItem.values.map((p) => p == item);

  @override
  final String key;

  PageItemListItem(this.item, this.selectedItem) : key = item.id {
    view = _makeView();
  }

  View view;

  View _makeView() {
    HBox ret;
    ret = HBox(class_: 'slidelist-item', children: [
      // TODO icon
      TextField(
          text: item.rx.name,
          class_: 'slidelist-label',
          onClick: () => selectedItem.value = item)
    ])
      ..classes.bindBool('selected', _selectionChange, isSelected);
    return ret;
  }
}

class PageItemList implements Component {
  @override
  String key;

  final List<PageItem> items;

  final StoredValue<PageItem> selectedItem;

  PageItemList(this.items, this.selectedItem, {this.key}) {
    view = _makeView();
  }

  View view;

  View _makeView() {
    return Box(
        class_: 'slidelist',
        children: items.map((page) => PageItemListItem(page, selectedItem)));
  }
}
