import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/view/home_page.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerSingleton<LocalStorage>(
    HiveLocalStorage(),
  );
}

Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  var taskBox = await Hive.openBox<TaskModel>('tasks');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  await setupHive();
  setup();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('tr', 'TR'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          localizationsDelegates:
              context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          debugShowCheckedModeBanner: false,
          title: 'ToDo App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
              primary: Colors.black,
              secondary: Colors.grey,
            ),
            buttonTheme: ButtonThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.white,
                primary: Colors.black,
                secondary: Colors.grey,
              ),
            ),
            primaryColor: Colors.black,
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: Colors.grey,
            floatingActionButtonTheme:
                FloatingActionButtonThemeData(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 4.0.r,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      40.0.r,
                    ),
                  ),
                ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
            ),
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
