import "package:test/test.dart";
import 'package:twfoodtranslations/utils/text_recognition.dart';

main() {
  test('cleanText()', () {
    expect(cleanText('123!'), '');
    expect(cleanText('滷肉飯'), '滷肉飯');
    expect(cleanText('一'), '');
  });
}
