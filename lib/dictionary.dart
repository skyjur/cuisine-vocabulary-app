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
    return term;
  }
}

const Dictionary = <Term>[
  Term(
      term: '鮮肉餛飩乾麵',
      pinYin: 'Xiān ròu húntún gān miàn',
      translation: 'Pork-Wonton dry noodle',
      description: '',
      imagePath: 'food_pictures/wonton_pork_dry_noodle.jpg'),
  Term(
      term: '滷排骨便當',
      pinYin: 'Lǔ páigǔ biàndang',
      translation: 'broiled pork-chop bento',
      description: '',
      imagePath: 'food_pictures/broil_pork_chop_bento.jpg'),
  Term(
      term: '焢肉便當',
      pinYin: 'Kòng ròu biàndang',
      translation: 'Fatty-pork bento',
      description: '',
      imagePath: 'food_pictures/fatty_pork_bento.jpg'),
  Term(
      term: '招牌便當',
      pinYin: 'Zhāopái biàndang',
      translation: 'Signature bento',
      description: '',
      imagePath: 'food_pictures/signature_bento.jpg'),
  Term(
      term: '辣味雞丁便當',
      pinYin: 'Là wèi jī dīng biàndang',
      translation: 'Spicy stir-fried chicken cube bento',
      description: '',
      imagePath: 'food_pictures/spicy_chicken_bento.jpg'),
  Term(
      term: '滷雞腿便當',
      pinYin: 'Lǔ jītuǐ biàndang',
      translation: 'Broiled chicken drumstick bento',
      description: '',
      imagePath: 'food_pictures/chicken_drumstick_bento.jpg'),
  Term(
      term: '菜飯便當',
      pinYin: 'Càifàn biàndang',
      translation: 'Vagetable bento',
      description: '',
      imagePath: 'food_pictures/vagetable_bento.jpg'),
  Term(
      term: '滷肉飯便當',
      pinYin: 'Lǔ ròu fàn biàndang',
      translation: 'Braised pork rice bento',
      description: '',
      imagePath: 'food_pictures/braised_pork_rice_bento.png'),
  Term(
      term: '大腸豬血湯',
      pinYin: 'Dàcháng zhu xie tang',
      translation: 'Pork intestine with pork blood soup',
      description: '',
      imagePath: 'food_pictures/pork_intestine_with_pork_blood_soup.jpg'),
  Term(
      term: '豬心湯',
      pinYin: 'Zhū xīn tāng',
      translation: 'Pork heart soup',
      description: '',
      imagePath: 'food_pictures/pork_heart_soup.jpg'),
  Term(
      term: '菜頭魚丸湯',
      pinYin: 'Cài tóu yú wán tāng',
      translation: 'Radish fish ball soup',
      description: '',
      imagePath: 'food_pictures/radish_fish_ball_soup.jpg'),
  Term(
      term: '青菜湯',
      pinYin: 'Qīngcài tāng',
      translation: 'Vagetable soup',
      description: '',
      imagePath: 'food_pictures/vagetable_soup.jpg'),
  Term(
      term: '魚丸湯',
      pinYin: 'Yú wán tāng',
      translation: 'Fish ball soup',
      description: '',
      imagePath: 'food_pictures/fish_ball_soup.jpg'),
  Term(
      term: '豬血湯',
      pinYin: 'Zhū xiě tāng',
      translation: 'Pork blood soup',
      description: '',
      imagePath: 'food_pictures/pork_blood_soup.jpg'),
  Term(
      term: '菜頭湯',
      pinYin: 'Cài tóu tāng',
      translation: 'Radish soup',
      description: '',
      imagePath: 'food_pictures/radish_soup.jpg'),
  Term(
      term: '嫩燙白肉片',
      pinYin: 'Nèn tàng bái ròupiàn',
      translation: 'Sliced pork',
      description: '',
      imagePath: 'food_pictures/pork_sliced.jpg'),
  Term(
      term: '麻油豬肝片',
      pinYin: 'Máyóu zhū gān piàn',
      translation: 'Sliced Sesame oil pork liver',
      description: '',
      imagePath: 'food_pictures/sesame_oil_pork_liver.jpg'),
  Term(
      term: '蒜瓣高麗菜',
      pinYin: 'Suànbàn gāolí cài',
      translation: 'Cabbage with garlic',
      description: '',
      imagePath: 'food_pictures/garlic_cabagge.jpg'),
  Term(
      term: '排骨麵',
      pinYin: 'Páigǔ miàn',
      translation: 'Pork rib noodle',
      description: '',
      imagePath: 'food_pictures/pork_rib_soup.jpg'),
  Term(
      term: '焢肉麵',
      pinYin: 'Kòng ròu miàn',
      translation: 'Fatty pork noodle',
      description: '',
      imagePath: 'food_pictures/fatty_pork_noodle.jpg'),
  Term(
      term: '雞腿麵',
      pinYin: 'jītuǐ miàn',
      translation: 'Chicken drumstick noodle',
      description: '',
      imagePath: 'food_pictures/chicken_drumstick_noodle.jpg'),
  Term(
      term: '滷肉飯',
      pinYin: 'Lǔ ròu fàn',
      translation: 'Braised pork rice',
      description: '',
      imagePath: 'food_pictures/braised_pork_rice.jpg'),
  Term(
      term: '菜頭湯',
      pinYin: 'Cài tóu tāng',
      translation: 'Radish soup',
      description: '',
      imagePath: 'food_pictures/radish_soup.jpg'),
];
