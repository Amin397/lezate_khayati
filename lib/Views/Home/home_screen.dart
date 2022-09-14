import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Plugins/neu/flutter_neumorphic.dart';
import 'package:lezate_khayati/Utils/view_utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../Controllers/Home/home_controller.dart';
import '../../Utils/Consts.dart';
import 'Widgets/build_home_top_slider.dart';
import 'Widgets/build_show_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: Colors.grey[200],
      child: Column(
        children: [
          SizedBox(
            height: Get.height * .04,
          ),
          _buildSearchBox(),
          SizedBox(
            height: Get.height * .01,
          ),
          Obx(
            () => (controller.isLoaded.isTrue)
                ? Expanded(
                    child: SizedBox(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            BuildHomeTopSliderWidget(
                              controller: controller,
                            ),
                            SizedBox(
                              height: Get.height * .02,
                            ),
                            if (controller.priceyCoursesList.isNotEmpty)
                              BuildShowListWidget(
                                controller: controller,
                                title: 'دوره های ویژه',
                                id: 0,
                                list: controller.priceyCoursesList,
                              ),
                            SizedBox(
                              height: Get.height * .02,
                            ),
                            if (controller.freeCoursesList.isNotEmpty)
                              BuildShowListWidget(
                                controller: controller,
                                title: 'دوره های رایگان',
                                id: 1,
                                list: controller.freeCoursesList,
                              ),
                            SizedBox(
                              height: Get.height * .02,
                            ),
                            _buildMainBanner(),
                            SizedBox(
                              height: Get.height * .02,
                            ),
                            if (controller.productsList.isNotEmpty)
                              BuildShowListWidget(
                                controller: controller,
                                title: 'محصولات',
                                id: 2,
                                list: controller.productsList,
                              ),
                            SizedBox(
                              height: Get.height * .02,
                            ),
                            if (controller.booksList.isNotEmpty)
                              BuildShowListWidget(
                                controller: controller,
                                title: 'کتاب ها',
                                id: 3,
                                list: controller.booksList,
                              ),
                            SizedBox(
                              height: Get.height * .02,
                            ),
                            if (controller.articlesList.isNotEmpty)
                              BuildShowListWidget(
                                controller: controller,
                                title: 'مقالات',
                                id: 4,
                                list: controller.articlesList,
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                : _buildShimmer(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(12),
        ),
        depth: -3,
        lightSource: LightSource.topLeft,
        color: Colors.grey[100],
      ),
      margin: paddingSymmetricH8,
      child: InkWell(
        onTap: (){
          controller.goToSearchPage();
        },
        child: Container(
          width: Get.width,
          height: Get.height * .05,
          padding: paddingAll4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Hero(
                tag:'search',
                child: Text(
                  'جستجو',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              Hero(
                tag: 'searchIcon',
                child: Icon(
                  Icons.search,
                  color: Colors.grey.shade700,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Expanded(
      child: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          children: [
            BuildHomeTopSliderWidget(
              controller: controller,
            ),
            _buildShimmerList(),
            SizedBox(
              height: Get.height * .02,
            ),
            _buildShimmerList(),
            Container(
              height: Get.height * .2,
              width: Get.width,
              child: Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(.2),
                highlightColor: Colors.white24,
                child: Container(
                  width: Get.width,
                  margin: paddingAll10,
                  height: Get.height * .25,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: radiusAll12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return SizedBox(
      width: Get.width,
      height: Get.height * .125,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) => _buildShimmerItem()),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      height: Get.height,
      width: Get.height * .12,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(.2),
        highlightColor: Colors.white24,
        child: Container(
          width: Get.width,
          margin: paddingAll10,
          height: Get.height * .25,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: radiusAll12,
          ),
        ),
      ),
    );
  }

  Widget _buildMainBanner() {
    return Container(
      width: Get.width,
      height: Get.height * .15,
      decoration: BoxDecoration(
        borderRadius: radiusAll10,
        boxShadow: ViewUtils.neoShadow(),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: Get.width * .1,
        vertical: Get.height * .01,
      ),
      child: ClipRRect(
        borderRadius: radiusAll10,
        child: Image(
          fit: BoxFit.cover,
          image: AssetImage('assets/img/mainBanner.png'),
        ),
      ),
    );
  }
}
