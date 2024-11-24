import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_starter/model/locale.dart';
import 'package:flutter_starter/utils/common.dart';
import 'package:provider/provider.dart';

const _defaultPadding = EdgeInsets.all(15);

class DefaultContainer extends StatelessWidget {
  final Widget body;
  final Widget? background;
  final Widget? bottomLeft;
  final Widget? bottomRight;
  final bool lightMode;

  const DefaultContainer({required this.body, this.background, this.bottomLeft, this.bottomRight, this.lightMode = false, super.key});

  @override
  Widget build(BuildContext context) {
    var loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: lightMode ? Colors.white : Colors.black,
      body: Stack(
        children: [
          if (background != null)
            background!,
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                body,
              ],
            ),
          ),
          Positioned(
            top: _defaultPadding.top,
            right: _defaultPadding.right,
            child: Consumer<LocaleModel>(
              builder: (context, localeModel, child) =>
                RoundButton(
                  onPressed: () => localeModel.swap(),
                  backgroundColor: lightMode ? Colors.black : Colors.white,
                  child: Text(loc.language, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: lightMode ? Colors.white : Colors.black)),
                ),
            ),
          ),
          if (bottomLeft != null)
            Positioned(
              bottom: _defaultPadding.bottom,
              left: _defaultPadding.left,
              child: bottomLeft!,
            ),
          if (bottomRight != null)
            Positioned(
              bottom: _defaultPadding.bottom,
              right: _defaultPadding.right,
              child: bottomRight!,
            ),
        ],
      ),
    );
  }
}