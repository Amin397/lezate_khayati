import 'package:flutter/widgets.dart';
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



  static void onChange({
    required String string,
    required TextEditingController textController,
    required Function func,

  }) {
    List<String> list = string.split('');
    if (list.isNotEmpty) {
      switch (list.length) {
        case 1:
          if (list[0] == '0') {
            textController.text = '0';
          } else {
            textController.clear();
          }
          break;
        case 2:
          if (list[1] == '9') {
            textController.text = '09';
          } else {
            textController.text = '0';
          }

          break;
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
          list.removeAt(0);
          list.removeAt(0);
          textController.text = '09' + list.join('');
          break;
      }
      if (textController.text.length == 11) {
        func();
      } else {
        Future.delayed(
          Duration.zero,
              () => textController.selection = TextSelection.fromPosition(
            TextPosition(
              offset: textController.text.length,
            ),
          ),
        );
      }
    }
  }



}
