import 'package:meta/meta.dart';

class Term {
  final String term;
  final String pinYin;
  final String translation;
  final String description;
  final String imagePath;

  const Term(
      {@required this.term,
      @required this.pinYin,
      @required this.translation,
      @required this.description,
      @required this.imagePath});

  @override
  String toString() {
    return 'term: $term';
  }
}

const Dictionary = <Term>[
  Term(
      term: '鮮肉餛飩乾麵',
      pinYin: 'Xiān ròu húntún gān miàn',
      translation: 'Pork-Wonton dry noodle',
      description: '',
      imagePath: 'food_pictures/wonton_pork_dry_noodle.jpg')
];
