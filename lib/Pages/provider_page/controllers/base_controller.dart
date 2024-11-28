import 'package:get/get.dart';

class BaseController extends GetxController {
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  void showLoading() => _isLoading.value = true;
  void hideLoading() => _isLoading.value = false;

  Future<T?> handleError<T>(Future<T> Function() task) async {
    try {
      showLoading();
      return await task();
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return null;
    } finally {
      hideLoading();
    }
  }
} 