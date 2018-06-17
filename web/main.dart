import 'dart:html';
import 'package:nuts/nuts.dart';
import 'package:nuts/html_renderer.dart';
import 'package:webclient/apps/designer/designer.dart';
import 'package:webclient/models/models.dart';

void main() {
  program = new Program(id: '41341234', name: 'Medis', pages: [
    Page(id: '1', name: 'Page1'),
    Page(id: '2', name: 'Page2'),
    Page(id: '3', name: 'Page3')
  ]);
  if(program.pages.length != 0) selectedPage = program.pages.first;
  Element e = defaultRenderers.render(Designer());
  document.body.children = [e];
}
