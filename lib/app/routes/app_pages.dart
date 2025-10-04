import 'package:get/get.dart';
import 'package:multi_admin/app/modules/sign_up/bindings/sign_up_binding.dart';
import 'package:multi_admin/app/modules/sign_up/views/sign_up_view.dart';

import '../modules/admin_view/bindings/admin_view_binding.dart';
import '../modules/admin_view/views/admin_view_view.dart';
import '../modules/signin/bindings/signin_binding.dart';
import '../modules/signin/views/signin_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // static const INITIAL = Routes.SINGUP;
  static const INITIAL = Routes.SIGNIN;

  static final routes = [
    GetPage(
      name: _Paths.SIGNIN,
      page: () => const SigninView(),
      binding: SigninBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_VIEW,
      page: () => AdminView(),
      binding: AdminViewBinding(),
    ),
    GetPage(
      name: _Paths.SINGUP,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
  ];
}
