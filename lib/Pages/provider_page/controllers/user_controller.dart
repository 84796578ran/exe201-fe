import 'package:get/get.dart';
import '../../../Models/user.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();
  
  final Rx<User?> _currentUser = Rx<User?>(null);
  User? get user => _currentUser.value;
  
  bool get isLoggedIn => _currentUser.value != null;
  bool get isProvider => _currentUser.value?.role == 'provider';
  bool get isAdmin => _currentUser.value?.role == 'admin';

  @override
  void onInit() {
    super.onInit();
    // Load user from local storage if exists
    // loadUserFromStorage();
  }

  void setUser(Map<String, dynamic> userData) {
    final user = User.fromJson(userData);
    _currentUser.value = user;
    // Save to local storage
    // saveUserToStorage(user);
  }

  void clearUser() {
    _currentUser.value = null;
    // Clear from local storage
    // clearUserFromStorage();
  }

  // Navigation helpers
  void toLogin() => Get.offNamed('/login');
  void toHome() => Get.offNamed('/home');
  void toProviderDashboard() => Get.offNamed('/provider/dashboard');
  
  // Snackbar helpers
  void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
} 