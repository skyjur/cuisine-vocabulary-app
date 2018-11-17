import "package:test/test.dart";
import 'package:twfoodtranslations/dictionary.dart';
import 'package:twfoodtranslations/dictionarySearch.dart';

Term makeTerm(String term) {
  return Term(
      term: term, description: '', pinYin: '', imagePath: '', translation: '');
}

void main() {
  final term1 = makeTerm('咖哩');
  final term2 = makeTerm('櫻花咖哩');
  final term3 = makeTerm('肉燥');
  final term4 = makeTerm('肉燥櫻花咖哩');
  final term5 = makeTerm('黃金');
  final dictionary = [term1, term2, term3, term4, term5];
  final index = DictionaryIndex(dictionary);

  test("No results", () {
    expect(index.search('不'), equals([]));
  });

  test("Single match", () {
    expect(index.search(term5.term), [term5]);
  });

  test("Better match first", () {
    expect(index.search('花咖哩'), [term2, term4, term1]);
  });
}
