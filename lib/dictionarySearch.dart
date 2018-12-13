import 'dart:math';

import 'package:twfoodtranslations/dictionary.dart';

class TermScore implements Comparable<TermScore> {
  int score;
  Term term;
  String query;
  TermScore(this.term, this.query) : this.score = _calcScore(term, query);

  static _calcScore(Term term, String query) {
    if (query.contains(term.term)) {
      return (term.term.length * 2 + query.length - query.indexOf(term.term)) *
          10;
    }
    return 0;
  }

  int compareTo(TermScore other) {
    return other.score.compareTo(score);
  }

  bool passMark() {
    // at least half characters should match query:
    return score >= 1;
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

    for (var i = 1; i < sortedScores.length; i++) {
      var t = sortedScores[i].term.term;
      for (var j = i - 1; j >= 0; j--) {
        if (sortedScores[j].term.term.contains(t)) {
          sortedScores[i].score ~/= 2;
        }
      }
    }
    sortedScores.sort();
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
