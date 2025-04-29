import 'package:darlink/constants/app_theme_data.dart';

import 'package:darlink/constants/database_url.dart';
import 'package:darlink/layout/home_layout.dart';

import 'package:darlink/shared/cubit/app_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  runApp(const DarLinkApp());
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
}

class DarLinkApp extends StatelessWidget {
  const DarLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: MaterialApp(
        title: 'Darlink',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: (true) ? AppThemeData.lightTheme : AppThemeData.darkTheme,
        home: HomeLayout(),
      ),
    );
  }
}
