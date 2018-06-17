import 'dart:async';
import 'package:nuts/nuts.dart';
import 'package:webclient/models/models.dart';

Program program;

final selectedPageBinding = new Bindable<Page>();

Page get selectedPage => selectedPageBinding.get;

set selectedPage(Page v) => selectedPageBinding.set = v;

class TitleBar implements Component {
  @override
  String key;

  String name;

  TitleBar(this.name, {this.key});

  @override
  View makeView() {
    return Box(class_: 'titlebar', children: [
      HBox(
          class_: 'title-holder', children: [TextField(name, class_: 'title')]),
    ]);
  }
}

class SlideItem implements Component {
  Page page;

  bool get isSelected => page == selectedPage;

  Stream<bool> get _selectionChange =>
      selectedPageBinding.onChanges.map((Change<Page> c) => c.neu == page);

  @override
  final String key;

  SlideItem(this.page) : key = page.id {}

  @override
  View makeView() {
    HBox ret;
    ret = HBox(class_: 'slidelist-item', children: [
      TextField(page.name,
          class_: 'slidelist-label', onClick: () => selectedPage = page)
    ])
      ..bindClass('selected', _selectionChange)
      ..classes.addIf(isSelected, 'selected');
    return ret;
  }
}

class SlideList implements Component {
  @override
  String key;

  List<Page> pages;

  SlideList(this.pages, {this.key});

  @override
  View makeView() {
    return Box(
        class_: 'slidelist', children: pages.map((page) => SlideItem(page)));
  }
}

class Designer implements Component {
  @override
  String key;

  @override
  View makeView() {
    selectedPageBinding.onChanges.listen((e) {
      print(e.neu.name);
    });
    return Box(children: [
      Box(
          class_: 'sidebar',
          children: [TitleBar(program.name), SlideList(program.pages)])
    ]);
  }
}
