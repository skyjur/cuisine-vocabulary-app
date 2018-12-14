import 'dart:io';

import 'package:twfoodtranslations/dictionary.dart';

void main() async {
  final dict = await loadDictionary();
  while (true) {
    final line = stdin.readLineSync();
    if (line == null) {
      return;
    }
    final query = line.trim();
    final result = dict.search(query);
    if (result.length > 0) {
    } else {
      print("$query: no results");
    }
  }
}
