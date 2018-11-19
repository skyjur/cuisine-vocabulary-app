import 'package:twfoodtranslations/dictionary.dart';

class TermScore implements Comparable<TermScore> {
  int score;
  Term term;
  String query;
  TermScore(this.term, this.query) : this.score = _calcScore(term, query);

  static _calcScore(Term term, String query) {
    int score = 0;
    for (var char in query.split('')) {
      if (term.term.contains(char)) {
        score += 1;
      }
    }
    return score * 10 + (10 - term.term.length);
  }

  int compareTo(TermScore other) {
    return other.score.compareTo(score);
  }

  bool passMark() {
    // at least half characters should match query:
    return (score ~/ 10) > (query.length ~/ 2);
  }
}

class DictionaryIndex {
  final List<Term> dictionary;
  final Map<String, List<Term>> _index;

  DictionaryIndex(this.dictionary) : _index = _buildIndex(dictionary);

  List<Term> search(String query) {
    var sortedScores = dictionary
        .map((term) => TermScore(term, query))
        .where((TermScore s) => s.passMark())
        .toList()
          ..sort();
    return sortedScores.map((score) => score.term).toList();
  }
}

Map<String, List<Term>> _buildIndex(List<Term> dictionary) {
  Map<String, List<Term>> index = {};
  for (var term in dictionary) {
    for (var char in term.term.split('')) {
      if (index.containsKey(char)) {
        index[char].add(term);
      } else {
        index[char] = [term];
      }
    }
  }
  return index;
}
