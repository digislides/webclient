import 'package:nuts/nuts.dart';
import 'package:webclient/models/models.dart';
import 'package:fontawesome/fontawesome.dart';

import 'property.dart';

class PageProperties implements Component {
  @override
  final String key;

  final Page page;

  PageProperties(this.page, {this.key}) {
    view = _makeView();
  }

  View view;

  View _makeView() {
    return Box(children: [
      ImageProperty(FASolid.image, page.rx.image),
      FitProperty(page.rx.fit),
      ColorProperty(FASolid.chess_board, page.rx.color),
    ]);
  }
}
