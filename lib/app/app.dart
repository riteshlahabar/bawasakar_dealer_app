import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/core_binding.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

class DealerApp extends StatelessWidget {
  const DealerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bawaskar Dealer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialBinding: CoreBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.cupertino,
    );
  }
}
