import 'package:get/get.dart';
import '../modules/admin_view/bindings/admin_view_binding.dart';
import '../modules/admin_view/views/admin_view_view.dart';
import '../modules/report_history/bindings/report_history_binding.dart';
import '../modules/report_history/views/report_history_view.dart';
import '../modules/sign_up/bindings/sign_up_binding.dart';
import '../modules/sign_up/views/sign_up_view.dart';
import '../modules/signin/bindings/signin_binding.dart';
import '../modules/signin/views/signin_view.dart';
import '../modules/tren_report_location/bindings/tren_report_location_binding.dart';
import '../modules/tren_report_location/views/tren_report_location_view.dart';
import '../modules/user_detail/bindings/user_detail_binding.dart';
import '../modules/user_detail/views/user_detail_view.dart';
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
      binding: AdminBinding(),
    ),
    GetPage(
      name: _Paths.SINGUP,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.USER_DETAIL,
      page: () => const UserDetailView(),
      binding: UserDetailBinding(),
    ),
    GetPage(
      name: _Paths.TREN_REPORT_LOCATION,
      page: () => const TrenReportLocationView(),
    ),
    GetPage(name: _Paths.REPORT_HISTORY, page: () => ReportHistoryView()),
  ];
}
