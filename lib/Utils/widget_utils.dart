import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/color_utils.dart';
import 'package:lezate_khayati/Utils/logic_utils.dart';

class WidgetUtils {
  static textField({
    String title = '',
    IconData? icon,
    TextEditingController? controller,
    TextAlign textAlign = TextAlign.center,
    TextInputType keyboardType = TextInputType.text,
    void Function(String string)? onChanged,
    FocusNode? focusNode,
    List<TextInputFormatter> formatter = const [],
    double letterSpacing = 1.9,
    bool enabled = true,
    bool? valid,
    int maxLines = 1,
    bool price = false,
    bool percent = false,
    Color? backgroundColor,
    double heightFactor = 21,
    Color? borderColor,
    bool password = false,
  }) {
    controller ??= TextEditingController();
    backgroundColor ??= ColorUtils.black;
    return Container(
      height: maxLines == 0
          ? Get.height / heightFactor
          : Get.height / (heightFactor / maxLines),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: backgroundColor,
      ),
      child: TextFormField(
        textAlign: textAlign,
        keyboardType: price ? TextInputType.number : keyboardType,
        controller: controller,
        maxLines: maxLines,
        enabled: enabled,
        focusNode: focusNode,
        cursorColor: ColorUtils.yellow,
        obscureText: password,
        textAlignVertical: TextAlignVertical.bottom,
        style: TextStyle(
          color: Colors.white,
          letterSpacing: letterSpacing,
          fontSize: 15.0,
        ),
        inputFormatters: [
          if (percent) LengthLimitingTextInputFormatter(3),
          if (percent || price) FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (String str) {
          if (price) {
            double value = double.parse(str.replaceAll(',', '').trim());
            controller!.text = LogicUtils.moneyFormat(value);
            controller.selection = TextSelection.fromPosition(
              TextPosition(
                offset: controller.text.length,
              ),
            );
          }
          if (percent) {
            double value;
            try {
              value = double.parse(str);
            } catch (e) {
              value = 0;
            }
            if (value > 100) {
              controller!.text = '100';
              controller.selection = TextSelection.fromPosition(
                TextPosition(
                  offset: controller.text.length,
                ),
              );
            }
          }
          if (onChanged != null) onChanged(str);
        },
        decoration: InputDecoration(
          hintText: title,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 12.0,
          ),
          hintMaxLines: 1,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: borderColor is Color
                  ? borderColor
                  : valid == true
                      ? ColorUtils.yellow
                      : valid is bool
                          ? ColorUtils.red
                          : ColorUtils.yellow.withOpacity(0.8),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: borderColor is Color
                  ? borderColor
                  : valid == true
                      ? ColorUtils.yellow
                      : valid is bool
                          ? ColorUtils.red
                          : ColorUtils.yellow.withOpacity(0.3),
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: borderColor is Color
                  ? borderColor
                  : valid == true
                      ? ColorUtils.yellow
                      : valid is bool
                          ? ColorUtils.red
                          : Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  static softButton({
    void Function()? onTap,
    double widthFactor = 4,
    String title = 'تایید',
    bool enabled = true,
    double fontSize = 14.0,
    MaterialColor? color,
    IconData? icon,
    bool reverse = false,
  }) {
    color ??= ColorUtils.yellow;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!reverse && icon is IconData) ...[
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(
                width: 8.0,
              ),
            ],
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
              ),
            ),
            if (reverse && icon is IconData) ...[
              const SizedBox(
                width: 8.0,
              ),
              Icon(
                icon,
                color: Colors.white,
              ),
            ],
          ],
        ),
        height: (Get.width > 400 ? Get.height / 24 : Get.height / 18),
        width: Get.width / widthFactor,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-1.0, -4.0),
            end: const Alignment(1.0, 4.0),
            colors: [
              if (!reverse) ...[
                enabled ? color : color.withOpacity(0.5),
                enabled ? color.shade800 : color.shade800.withOpacity(0.5),
              ],
              if (reverse) ...[
                enabled ? color.shade800 : color.shade800.withOpacity(0.5),
                enabled ? color : color.withOpacity(0.5),
              ],
            ],
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: color.shade700.withOpacity(0.7),
              offset: const Offset(1.0, 1.0),
              blurRadius: 6.0,
              spreadRadius: 1.0,
            ),
            BoxShadow(
              color: color.withOpacity(0.2),
              offset: const Offset(-2.0, -2.0),
              blurRadius: 6.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
      ),
    );
  }
}
