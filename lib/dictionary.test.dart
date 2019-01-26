import "package:test/test.dart";
import 'package:foodvocabularyapp/dictionary.dart';

Term makeTerm(String term) {
  return Term(
      term: term, description: '', pinYin: '', imageUrl: '', translation: '');
}

void main() {
  final term1 = makeTerm('咖哩');
  final term2 = makeTerm('櫻花咖哩');
  final term3 = makeTerm('肉燥');
  final term4 = makeTerm('肉燥櫻花咖哩');
  final term5 = makeTerm('黃金');
  final term6 = makeTerm('咖');
  final dictionary = [term1, term2, term3, term4, term5, term6];
  final index = Dictionary(dictionary);

  test("No results", () {
    expect(index.search('不'), equals([]));
  });

  test("Single match", () {
    expect(index.search(term5.term), [term5]);
  });

  test("Better match first", () {
    // term6 shoudn't show up here because less than half characters are matched:
    expect(index.search('花咖哩'), [term2, term4, term1]);
  });

  test("Shortest match first", () {
    expect(index.search('咖'), [term6, term1, term2, term4]);
  });
}
