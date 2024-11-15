import 'dart:math';

Random _rnd = Random();

int getRandomInt({int min = 0, int max = 100}) => min + _rnd.nextInt(max - min);

///Returns random text of added length
String getRandomString(int length) {
  const String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return String.fromCharCodes(Iterable<int>.generate(
    length,
    (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
  ));
}

T getRandomValueFromList<T>(List<T> list) =>
    list[getRandomInt(max: list.length)];
