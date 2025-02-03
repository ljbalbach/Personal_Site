import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_starter/pages/home.dart';
import 'package:flutter_starter/utils/constants.dart';
import 'package:flutter_starter/model/theme_model.dart';
import 'model/locale.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage(WINTER), context);
    precacheImage(const AssetImage(SUMMER), context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocaleModel()),
        ChangeNotifierProvider(create: (context) => ThemeModel()),
      ],
      child: Consumer2<LocaleModel, ThemeModel>(
        builder: (context, localeModel, themeModel, child) => MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: localeModel.locale,
          theme: themeModel.currentTheme,
          home: const Directionality(
            textDirection: TextDirection.ltr,
            child: Home(),
          ),
        )
      )
    );
  }
}