import 'package:persian_number_utility/persian_number_utility.dart';

class LogicUtils {
  static List<List<T>> generateChunks<T>(List<T> inList, int chunkSize) {
    List<List<T>> outList = [];
    List<T> tmpList = [];
    int counter = 0;

    for (int current = 0; current < inList.length; current++) {
      if (counter != chunkSize) {
        tmpList.add(inList[current]);
        counter++;
      }
      if (counter == chunkSize || current == inList.length - 1) {
        outList.add(tmpList.toList());
        tmpList.clear();
        counter = 0;
      }
    }

    return outList;
  }

  static String moneyFormat(
    double? price, [
    bool showText = true,
  ]) {
    price ??= 0.0;
    return price.toInt().toString().seRagham() + (showText ? " تومان" : '');
  }
}
