import 'dart:ui';

class TextWithPoint {
  final Paragraph text;
  final Offset point;

  TextWithPoint(this.text, this.point);

  @override
  String toString() {
    return 'TextWithPoint{_text: $text, _point: $point}';
  }
}
