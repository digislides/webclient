import 'dart:html';
import 'package:nuts/nuts.dart';
import 'package:nuts/html_renderer.dart';
import 'package:webclient/apps/designer/designer.dart';
import 'package:webclient/models/models.dart';

void main() {
  program = new Program(
      id: '41341234',
      name: 'Medis',
      width: 150,
      height: 150,
      pages: [
        Page(
            id: '1',
            name: 'Page1',
            width: 150,
            height: 150,
            color: 'white',
            items: [
              TextItem(
                  id: '1',
                  width: 100,
                  height: 100,
                  left: 25,
                  top: 25,
                  color: 'tomato')
            ]),
        Page(id: '2', name: 'Page2', width: 150, height: 150, color: 'blue'),
        Page(id: '3', name: 'Page3', width: 150, height: 150, color: 'green')
      ]);
  if (program.pages.length != 0) selectedPage.value = program.pages.first;
  Element e = defaultRenderers.render(Designer());
  document.body.children = [e];
}
