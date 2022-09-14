import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lezate_khayati/Utils/Consts.dart';

class ShowUploadedImageModal extends StatefulWidget {
  ShowUploadedImageModal(
      {Key? key, required this.isSub, this.file, this.imageLink})
      : super(key: key);

  File? file;
  final bool isSub;
  String? imageLink;

  @override
  State<ShowUploadedImageModal> createState() => _ShowUploadedImageModalState();
}

class _ShowUploadedImageModalState extends State<ShowUploadedImageModal> {
  Size? size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      height: size!.height * .7,
      width: size!.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.clear,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              margin: paddingAll10,
              child: ClipRRect(
                borderRadius: radiusAll10,
                child: (widget.isSub)
                    ? Image(
                        image: NetworkImage(
                          widget.imageLink!,
                        ),
                        fit: BoxFit.cover,
                      )
                    : Image(
                        image: FileImage(
                          widget.file!,
                        ),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
