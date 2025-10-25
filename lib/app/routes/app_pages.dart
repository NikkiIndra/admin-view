import 'package:get/get.dart';

import '../modules/admin_maps_report/bindings/admin_maps_report_binding.dart';
import '../modules/admin_maps_report/views/admin_maps_report_view.dart';
import '../modules/admin_view/views/admin_view_view.dart';
import '../modules/create_news/views/create_news_view.dart';
import '../modules/navbar/bindings/navbar_binding.dart';
import '../modules/navbar/views/navbar_view.dart';
import '../modules/news_uploads/views/news_uploads_view.dart';
import '../modules/report_history/views/report_history_view.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/sign_up/bindings/sign_up_binding.dart';
import '../modules/sign_up/views/sign_up_view.dart';
import '../modules/signin/bindings/signin_binding.dart';
import '../modules/signin/views/signin_view.dart';
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
    GetPage(
      name: _Paths.NAVBAR,
      page: () => NavbarView(),
      binding: NavbarBinding(),
      children: [
        // Tambahkan nested routes di sini
        GetPage(name: _Paths.ADMIN_VIEW, page: () => AdminView()),
        GetPage(name: _Paths.CREATE_NEWS, page: () => CreateNewsView()),
        GetPage(name: _Paths.NEWS_UPLOADS, page: () => NewsUploadsView()),
        GetPage(name: _Paths.SETTINGS, page: () => SettingsView()),
      ],
    ),
    GetPage(
      name: _Paths.ADMIN_MAPS_REPORT,
      page: () => AdminMapsReportView(),
      binding: AdminMapsReportBinding(),
    ),
  ];
}
