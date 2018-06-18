import 'package:nuts/nuts.dart';
import 'package:webclient/models/models.dart';

class Stage implements Component {
  @override
  String key;

  final Page page;

  Stage(this.page, {this.key});

  @override
  View makeView() => HBox(child: TextField(text: page.name), class_: 'stage');
}