import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:utf/utf.dart';

class Term {
  final String term;
  final String pinYin;
  final String translation;
  final String description;
  final String imageUrl;

  const Term(
      {@required this.term,
      @required this.pinYin,
      @required this.translation,
      this.description,
      this.imageUrl});

  @override
  String toString() {
    return term;
  }
}

Future<http.Response> _fetchUrl(String url) async {
  while (true) {
    try {
      print('getting $url');
      return await http.get(url);
    } catch (e) {
      print(e.toString());
      await Future.delayed(Duration(seconds: 5));
    }
  }
}

Future<Dictionary> loadDictionary() async {
  final repoLocation = 'https://skijur.com/food-vocabulary-app';
  final resp = await _fetchUrl("$repoLocation/dictionary.txt");
  final data = decodeUtf8(resp.bodyBytes);
  return Dictionary.fromCsv(data, repoLocation);
}

class Dictionary {
  Dictionary(this.terms) {
    print('Loaded dictionary with ${terms.length} terms');
  }

  List<Term> terms;

  static Dictionary fromCsv(String data, String repoLocation) {
    return Dictionary(data
        .split("\n")
        .where((line) => line.split("\t").length >= 2)
        .map((String line) {
      final l = line.split('\t') + ["", "", "", ""];
      return Term(
          term: l[0].trim(),
          pinYin: l[1].trim(),
          translation: l[2].trim(),
          imageUrl: l[3].trim() == "" ? null : "$repoLocation/${l[3].trim()}");
    }).toList());
  }

  List<Term> search(String query) {
    var sortedScores = terms
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

  Term getTermByValue(String text) {
    return terms.firstWhere((row) => row.term == text);
  }
}

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
