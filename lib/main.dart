import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/di/di.dart';
import 'core/helpers/custom_bloc_observer.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/view/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  Bloc.observer = CustomBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.appTheme,
          home: HomeScreen(),
        );
      },
    );
  }
}
