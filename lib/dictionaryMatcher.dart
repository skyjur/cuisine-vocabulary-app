import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:meta/meta.dart';
import 'package:twfoodtranslations/dictionary.dart';

class TextBlock {
  final String text;
  final int top;
  final int left;
  final int right;
  final int bottom;
  final List<Term> termMatch;
  const TextBlock(
      {@required this.text,
      @required this.top,
      @required this.left,
      @required this.right,
      @required this.bottom,
      this.termMatch});

  operator ==(dynamic other) {
    return other.text == text;
  }

  @override
  int get hashCode => this.text.hashCode;
}

List<TextBlock> dictionaryMatcher(VisionText visionText) {
  var result = <TextBlock>[];
  var i = 1;
  for (var block in visionText.blocks) {
    for (var fullLine in block.lines) {
      for (var elm in fullLine.elements) {
        // remove all ASCII symbols - we only care about chinese characters:
        final text = cleanText(elm.text);

        if (text != '') {
          print(
              '$text ${elm.boundingBox.top}x${elm.boundingBox.left} ${elm.boundingBox.width}x${elm.boundingBox.height}');

          result.add(TextBlock(
              text: text,
              top: elm.boundingBox.top,
              left: elm.boundingBox.left,
              bottom: elm.boundingBox.bottom,
              right: elm.boundingBox.right,
              termMatch:
                  Dictionary.where((t) => t.term.contains(text)).toList()));
        }
      }
    }
  }
  return result;
}

String cleanText(String text) {
  return text
      .replaceAll(RegExp(r'[^\u4E00-\u9FA5]'), '')
      .replaceAll('一', '')
      .trim();
}
