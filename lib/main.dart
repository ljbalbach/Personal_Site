import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_starter/pages/home.dart';
import 'package:flutter_starter/utils/constants.dart';
import 'model/locale.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage(WINTER), context);
    precacheImage(const AssetImage(SUMMER), context);
    return ChangeNotifierProvider(
      create: (context) => LocaleModel(),
      child: Consumer<LocaleModel>(
        builder: (context, localeModel, child) => MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: localeModel.locale,
          theme: ThemeData(
            useMaterial3: true,

            // Define the default brightness and colors.
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.black,
            ),
            textTheme: TextTheme(
              displayLarge: GoogleFonts.rock3d(
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ),
              titleLarge: GoogleFonts.caveatBrush(
                fontSize: 40,
              ),
              bodyMedium: GoogleFonts.caveatBrush(
                fontSize: 23,
              ),
              displaySmall: GoogleFonts.caveatBrush(
                fontSize: 21,
              ),
            ),
          ),
          home: const Directionality(
            textDirection: TextDirection.ltr, // or TextDirection.rtl if your app supports right-to-left
            child: Home(),
          ),
        )
      )
    );
  }
}