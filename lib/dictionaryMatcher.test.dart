import "package:test/test.dart";
import 'package:twfoodtranslations/dictionary.dart';
import 'package:twfoodtranslations/dictionaryMatcher.dart';
import 'package:twfoodtranslations/dictionarySearch.dart';

main() {
  test('cleanText()', () {
    expect(cleanText('123!'), '');
    expect(cleanText('滷肉飯'), '滷肉飯');
  });
}
