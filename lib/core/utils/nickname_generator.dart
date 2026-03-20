import 'dart:math';

const _adjectives = [
  '깔끔한', '빠른', '거품가득', '반짝이는', '시원한',
  '물방울', '새차같은', '윤기나는', '산뜻한', '청결한',
  '싹싹한', '말끔한', '번쩍이는', '향기로운', '깨끗한',
];

const _nouns = [
  '세차왕', '버킷', '워셔', '스펀지', '왁스달인',
  '세차요정', '물총', '폼건', '타올', '세차마스터',
  '광택왕', '거품손', '호스달인', '세차러', '클리너',
];

String generateNickname() {
  final rng = Random();
  final adj = _adjectives[rng.nextInt(_adjectives.length)];
  final noun = _nouns[rng.nextInt(_nouns.length)];
  final num = 100 + rng.nextInt(900); // 100~999
  return '$adj$noun$num';
}
