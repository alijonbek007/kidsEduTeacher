import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_edu_teacher/constants/colors.dart';
import 'package:kids_edu_teacher/view/library/logic/get_document_collections_bloc/get_document_collections_bloc.dart';
import 'package:kids_edu_teacher/view/main_app/initial_page.dart';
import 'package:kids_edu_teacher/view/main_app/main_app.dart';
import 'package:kids_edu_teacher/view/videos/logic/get_user_data_bloc/get_user_data_bloc.dart';
import 'package:kids_edu_teacher/view/videos/logic/get_video_collections_bloc/get_video_collections_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final appDir = await getTemporaryDirectory();
  if (appDir.existsSync()) {
    appDir.deleteSync(recursive: true);
  }
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  bool hasVerified = _prefs.getString('userId') != null;
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
        Locale('uz'),
      ],
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      path: "assets/translations",
      child: KidsEduApp(
        hasVerified: hasVerified,
      ),
    ),
  );
}

class KidsEduApp extends StatelessWidget {
  final bool hasVerified;
  const KidsEduApp({Key? key, required this.hasVerified}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kids Edu',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      // initialRoute:
      //     hasVerified ? MainAppScreen.routeName : InitialPage.routeName,
      onGenerateRoute: Routes.generateRoute,
      home: hasVerified
          ? MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => GetVideoCollectionsBloc(),
                ),
                BlocProvider(
                  create: (context) => GetUserDataBloc(),
                ),
                BlocProvider(
                  create: (context) => GetDocumentCollectionsBloc(),
                ),
              ],
              child: const MainAppScreen(),
            )
          : const InitialPage(),
      theme: ThemeData(
        primaryColor: Pallate.mainColor,
        fontFamily: GoogleFonts.nunito().fontFamily,
      ),
    );
  }
}
// test git
