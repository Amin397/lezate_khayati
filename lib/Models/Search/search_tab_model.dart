import 'package:lezate_khayati/Plugins/get/get.dart';

class SearchTabModel{


  int id;
  String title;
  RxInt searchCount;
  RxBool isSelected;

  SearchTabModel({required this.id, required this.title, required this.searchCount, required this.isSelected});
}