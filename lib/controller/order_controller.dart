
import 'package:get/get.dart';
import 'package:mad/model/orders.dart';

class OrderController extends GetxController {

  var isLoading = true.obs;
  var orderList = <Orders>[].obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 2));
    isLoading(false);
  }
}