import 'dart:async';
import 'package:nuts/nuts.dart';
import 'package:webclient/models/models.dart';
import 'package:fontawesome/fontawesome.dart';

export 'image.dart';
export 'text.dart';
export 'video.dart';

class PositionProperty implements Component {
  @override
  final String key;

  final PageItem item;

  PositionProperty(this.item, {this.key}) {
    view = _makeView();
  }

  View view;

  View _makeView() {
    return HBox(children: [
      IconEdit<int>(IntEdit(value: item.rx.left),
          icon: FASolid.angle_right,
          width: FlexSize(1.0),
          onCommit: (ValueCommitEvent<int> vc) => item.left = vc.value ?? 0),
      TextField(text: ':'),
      IconEdit<int>(IntEdit(value: item.rx.top),
          icon: FASolid.angle_down,
          width: FlexSize(1.0),
          onCommit: (ValueCommitEvent<int> vc) => item.top = vc.value ?? 0)
    ], classes: [
      'ech-field',
      'ech-field-two'
    ]);
  }
}

class SizeProperty implements Component {
  @override
  final String key;

  final PageItem item;

  SizeProperty(this.item, {this.key}) {
    view = _makeView();
  }

  View view;

  View _makeView() {
    return HBox(children: [
      IconEdit<int>(IntEdit(value: item.rx.width),
          icon: FASolid.arrows_alt_h,
          width: FlexSize(1.0),
          onCommit: (ValueCommitEvent<int> vc) => item.width = vc.value ?? 0),
      TextField(text: ':'),
      IconEdit<int>(IntEdit(value: item.rx.height),
          icon: FASolid.arrows_alt_v,
          width: FlexSize(1.0),
          onCommit: (ValueCommitEvent<int> vc) => item.height = vc.value ?? 0)
    ], classes: [
      'ech-field',
      'ech-field-two'
    ]);
  }
}

class ColorProperty implements Component {
  final String icon;
  final RxValue<String> property;

  @override
  final String key;

  final editor = RxValue<bool>();

  ColorProperty(this.icon, this.property, {this.key}) {
    view = _makeView();
  }

  View view;

  View _makeView() {
    var colorItemView = List<View>(colors.length);
    for (int i = 0; i < colors.length; i++) {
      String color = colors.keys.elementAt(i);
      colorItemView[i] = HBox(
          class_: 'ech-colors-list-item',
          children: [
            Box(backgroundColor: colors[color], class_: 'ech-color-display'),
            TextField(text: color)
          ],
          onClick: () => property.value = colors[color]);
    }
    return Box(class_: 'ech-field', children: [
      HBox(
        classes: ['ech-superdropdownedit', 'ech-coloredit'],
        children: [
          TextField(
              text: icon, fontFamily: 'fa5-free', class_: 'ech-field-label'),
          Box(class_: 'ech-color-display', backgroundColor: property),
          TextEdit(
              value: property,
              width: FlexSize(1.0),
              onCommit: (ValueCommitEvent<String> v) {
                // TODO validate?
                property.value = v.value;
              })
            ..classes.add('textinput')
            ..classes.remove('textinput'),
          TextField(
              text: FASolid.list,
              fontFamily: 'fa5-free',
              class_: 'ech-field-action',
              onClick: () {
                if (editor.value == false) {
                  editor.value = null;
                  return;
                }
                editor.value = false;
              })
            ..classes.bindBool('selected', editor.map((v) => v == false)),
          TextField(
              text: FASolid.palette,
              fontFamily: 'fa5-free',
              class_: 'ech-field-action',
              onClick: () {
                if (editor.value == true) {
                  editor.value = null;
                  return;
                }
                editor.value = true;
              })
            ..classes.bindBool('selected', editor.map((v) => v == true)),
        ],
      ),
      VariableView<bool>.rx(editor, (b) {
        if (b == false)
          return Box(class_: 'ech-colors-list', children: colorItemView);
        if (b == true) return Box();
        return Box();
      }),
    ]);
  }
}

class IconEdit<T> implements Component, EditView<T> {
  final String key;
  final TextField iconField;
  final EditWidget<T> labelled;
  final /* Distance | Stream<Distance> | Reactive<Distance> */ width;
  final /* Distance | Stream<Distance> | Reactive<Distance> */ height;
  IconEdit(
    this.labelled, {
    String icon,
    this.width,
    this.height,
    TextField labelField,
    this.key,
    /* Callback | ValueCallback<String> */ onCommit,
  }) : iconField = labelField ?? TextField(text: icon, fontFamily: 'fa5-free') {
    labelled.classes.add('textinput');
    labelled.classes.remove('textinput');
    if (onCommit != null) this.onCommit.on(onCommit);
    view = _makeView();
  }

  View view;

  View _makeView() {
    return HBox(
        class_: 'ech-iconedit',
        children: [
          iconField,
          labelled,
        ],
        width: width,
        height: height);
  }

  ProxyValue<T> get valueProperty => labelled.valueProperty;
  T get value => labelled.value;
  set value(T value) => valueProperty.value = value;
  void setCastValue(v) => valueProperty.value = value;
  StreamBackedEmitter<ValueCommitEvent<T>> get onCommit => labelled.onCommit;
}

class FitProperty implements Component {
  final RxValue<Fit> property;

  @override
  final String key;

  final editor = RxValue<bool>(initial: false);

  FitProperty(this.property, {this.key}) {
    view = _makeView();
  }

  View view;

  View _makeView() {
    return Box(class_: 'ech-field', children: [
      HBox(
        classes: ['ech-superdropdownedit', 'ech-fitedit'],
        children: [
          TextField(
              text: FASolid.expand,
              fontFamily: 'fa5-free',
              class_: 'ech-field-label'),
          TextField(
              text: property.map((f) => f.name),
              width: FlexSize(1.0),
              class_: 'ech-dropdown-value'),
          TextField(
              text:
                  editor.map((v) => v ? FASolid.angle_up : FASolid.angle_down),
              fontFamily: 'fa5-free',
              class_: 'ech-field-action',
              onClick: () => editor.value = !editor.value)
            ..classes.bindBool('selected', editor.map((v) => v == true)),
        ],
      ),
      VariableView<bool>.rx(editor, (b) {
        if (b)
          return Box(
              class_: 'ech-colors-list',
              children: Fit.values.map((Fit fit) => HBox(
                  class_: 'ech-colors-list-item',
                  children: [TextField(text: fit.name)],
                  onClick: () => property.value = fit)));
        return Box();
      }),
    ]);
  }
}

final colors = {
  "aliceblue": "#f0f8ff",
  "antiquewhite": "#faebd7",
  "aqua": "#00ffff",
  "aquamarine": "#7fffd4",
  "azure": "#f0ffff",
  "beige": "#f5f5dc",
  "bisque": "#ffe4c4",
  "black": "#000000",
  "blanchedalmond": "#ffebcd",
  "blue": "#0000ff",
  "blueviolet": "#8a2be2",
  "brown": "#a52a2a",
  "burlywood": "#deb887",
  "cadetblue": "#5f9ea0",
  "chartreuse": "#7fff00",
  "chocolate": "#d2691e",
  "coral": "#ff7f50",
  "cornflowerblue": "#6495ed",
  "cornsilk": "#fff8dc",
  "crimson": "#dc143c",
  "cyan": "#00ffff",
  "darkblue": "#00008b",
  "darkcyan": "#008b8b",
  "darkgoldenrod": "#b8860b",
  "darkgray": "#a9a9a9",
  "darkgreen": "#006400",
  "darkgrey": "#a9a9a9",
  "darkkhaki": "#bdb76b",
  "darkmagenta": "#8b008b",
  "darkolivegreen": "#556b2f",
  "darkorange": "#ff8c00",
  "darkorchid": "#9932cc",
  "darkred": "#8b0000",
  "darksalmon": "#e9967a",
  "darkseagreen": "#8fbc8f",
  "darkslateblue": "#483d8b",
  "darkslategray": "#2f4f4f",
  "darkslategrey": "#2f4f4f",
  "darkturquoise": "#00ced1",
  "darkviolet": "#9400d3",
  "deeppink": "#ff1493",
  "deepskyblue": "#00bfff",
  "dimgray": "#696969",
  "dimgrey": "#696969",
  "dodgerblue": "#1e90ff",
  "firebrick": "#b22222",
  "floralwhite": "#fffaf0",
  "forestgreen": "#228b22",
  "fuchsia": "#ff00ff",
  "gainsboro": "#dcdcdc",
  "ghostwhite": "#f8f8ff",
  "gold": "#ffd700",
  "goldenrod": "#daa520",
  "gray": "#808080",
  "green": "#008000",
  "greenyellow": "#adff2f",
  "grey": "#808080",
  "honeydew": "#f0fff0",
  "hotpink": "#ff69b4",
  "indianred": "#cd5c5c",
  "indigo": "#4b0082",
  "ivory": "#fffff0",
  "khaki": "#f0e68c",
  "lavender": "#e6e6fa",
  "lavenderblush": "#fff0f5",
  "lawngreen": "#7cfc00",
  "lemonchiffon": "#fffacd",
  "lightblue": "#add8e6",
  "lightcoral": "#f08080",
  "lightcyan": "#e0ffff",
  "lightgoldenrodyellow": "#fafad2",
  "lightgray": "#d3d3d3",
  "lightgreen": "#90ee90",
  "lightgrey": "#d3d3d3",
  "lightpink": "#ffb6c1",
  "lightsalmon": "#ffa07a",
  "lightseagreen": "#20b2aa",
  "lightskyblue": "#87cefa",
  "lightslategray": "#778899",
  "lightslategrey": "#778899",
  "lightsteelblue": "#b0c4de",
  "lightyellow": "#ffffe0",
  "lime": "#00ff00",
  "limegreen": "#32cd32",
  "linen": "#faf0e6",
  "magenta": "#ff00ff",
  "maroon": "#800000",
  "mediumaquamarine": "#66cdaa",
  "mediumblue": "#0000cd",
  "mediumorchid": "#ba55d3",
  "mediumpurple": "#9370db",
  "mediumseagreen": "#3cb371",
  "mediumslateblue": "#7b68ee",
  "mediumspringgreen": "#00fa9a",
  "mediumturquoise": "#48d1cc",
  "mediumvioletred": "#c71585",
  "midnightblue": "#191970",
  "mintcream": "#f5fffa",
  "mistyrose": "#ffe4e1",
  "moccasin": "#ffe4b5",
  "navajowhite": "#ffdead",
  "navy": "#000080",
  "oldlace": "#fdf5e6",
  "olive": "#808000",
  "olivedrab": "#6b8e23",
  "orange": "#ffa500",
  "orangered": "#ff4500",
  "orchid": "#da70d6",
  "palegoldenrod": "#eee8aa",
  "palegreen": "#98fb98",
  "paleturquoise": "#afeeee",
  "palevioletred": "#db7093",
  "papayawhip": "#ffefd5",
  "peachpuff": "#ffdab9",
  "peru": "#cd853f",
  "pink": "#ffc0cb",
  "plum": "#dda0dd",
  "powderblue": "#b0e0e6",
  "purple": "#800080",
  "rebeccapurple": "#663399",
  "red": "#ff0000",
  "rosybrown": "#bc8f8f",
  "royalblue": "#4169e1",
  "saddlebrown": "#8b4513",
  "salmon": "#fa8072",
  "sandybrown": "#f4a460",
  "seagreen": "#2e8b57",
  "seashell": "#fff5ee",
  "sienna": "#a0522d",
  "silver": "#c0c0c0",
  "skyblue": "#87ceeb",
  "slateblue": "#6a5acd",
  "slategray": "#708090",
  "slategrey": "#708090",
  "snow": "#fffafa",
  "springgreen": "#00ff7f",
  "steelblue": "#4682b4",
  "tan": "#d2b48c",
  "teal": "#008080",
  "thistle": "#d8bfd8",
  "tomato": "#ff6347",
  "turquoise": "#40e0d0",
  "violet": "#ee82ee",
  "wheat": "#f5deb3",
  "white": "#ffffff",
  "whitesmoke": "#f5f5f5",
  "yellow": "#ffff00",
  "yellowgreen": "#9acd32"
};
