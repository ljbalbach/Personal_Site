import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_starter/containers/default_container.dart';
import 'package:flutter_starter/containers/photo_grid.dart';
import 'package:flutter_starter/containers/rounded_text_container.dart';
import 'package:flutter_starter/utils/common.dart';
import 'package:flutter_starter/utils/constants.dart';
import 'package:flutter_starter/utils/snow.dart';
import 'package:flutter_starter/model/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

final List<Color> _jColors = [
  const Color.fromARGB(255, 226, 130, 244).withOpacity(0.9),
  Colors.green.withOpacity(0.9),
  Colors.yellow.withOpacity(0.9),
  Colors.red.withOpacity(0.9),
  Colors.tealAccent.withOpacity(0.9)
];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _seasonsImageRotationAnimation;
  
  ExpansionTileController aboutController = ExpansionTileController();
  ExpansionTileController experienceController = ExpansionTileController();
  ExpansionTileController projectsController = ExpansionTileController();
  ExpansionTileController photosController = ExpansionTileController();
  late Timer _timer;
  int _colorIndex = 0;
  int _menuIndex = -1;
  bool _winter = true;
  bool _preloadWinter = true;
  bool _monoTone = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _seasonsImageRotationAnimation = Tween<double>(begin: 0, end: 7 * pi).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut)
    );
    _seasonsImageRotationAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _winter = !_winter;
        Provider.of<ThemeModel>(context, listen: false).toggleTheme();
        setState(() {});
      }
    });
    _timer = Timer.periodic(const Duration(seconds: 7), (Timer t) {
      _colorIndex = (_colorIndex + 1).remainder(_jColors.length);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeModel = Provider.of<ThemeModel>(context).currentTheme;
    Color primaryColor = themeModel.primaryColor;
    Color secondaryColor = themeModel.secondaryHeaderColor;
    AppLocalizations loc = AppLocalizations.of(context);
    List<ExpansionTileController> expansionControllers = [aboutController, experienceController, projectsController, photosController];

    return DefaultContainer(
      background: Stack(
        children: [
          if (!_preloadWinter || !_winter)
            Opacity(
              opacity: !_monoTone && !_winter ? 1 : 0,
              child: Image.asset(
                SUMMER,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          if (_preloadWinter || _winter)
            Opacity(
              opacity: !_monoTone && _winter ? 1 : 0,
              child: Image.asset(
                WINTER,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
        ],
      ),
      bottomLeft: _monoTone ? Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(children: [
          SocialLink(logo: GITHUB, link: "https://github.com/ljbalbach", color: secondaryColor, loc: loc),
          SocialLink(logo: LINKEDIN, link: "https://www.linkedin.com/in/lucas-balbach-950002108/", color: secondaryColor, loc: loc),
        ]),
      ) : null,
      bottomRight: GestureDetector(
        onTap: () {
          _preloadWinter = !_preloadWinter;
          setState(() {});

          double endRotation = _winter ? 7 * pi : 8 * pi; // 5.5 for upside down, 6.5 for right side up
          _seasonsImageRotationAnimation = Tween<double>(begin: _winter ? 0 : pi, end: endRotation).animate(
            CurvedAnimation(parent: _animationController, curve: Curves.easeOut)
          );
          _animationController.reset();
          _animationController.forward();
          setState(() {});
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 6,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedBuilder(
              animation: _seasonsImageRotationAnimation,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationZ(_seasonsImageRotationAnimation.value),
                  child: child,
                );
              },
              child: Image.asset(SEASONS),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          if (_winter && !_monoTone) const Snowfall(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NameWidget(
                  loc: loc,
                  onPressed: () {
                    _monoTone = !_monoTone;
                    if (!_monoTone) {
                      _menuIndex = -1;
                    }
                    setState(() {});
                  },
                  textColor: secondaryColor,
                  colorIndex: _colorIndex,
                ),
                if (_monoTone) Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MenuItem(
                      text: loc.about,
                      onPressed: () {
                        if (_menuIndex == 0) {
                          _menuIndex = -1;
                        } else {
                          _menuIndex = 0;
                        }
                        setState(() {});
                      },
                      controller: aboutController,
                      previousController: _menuIndex == -1 ? null : expansionControllers[_menuIndex],
                      color: _menuIndex == 0 ? _jColors[_colorIndex] : secondaryColor,
                      children: [
                        TextWidget(text: loc.about_description),
                      ],
                    ),
                    MenuItem(
                      text: loc.experience,
                      onPressed: () {
                        if (_menuIndex == 1) {
                          _menuIndex = -1;
                        } else {
                          _menuIndex = 1;
                        }
                        setState(() {});
                      },
                      controller: experienceController,
                      previousController: _menuIndex == -1 ? null : expansionControllers[_menuIndex],
                      color: _menuIndex == 1 ? _jColors[_colorIndex] : secondaryColor,
                      children: [
                        ExperienceWidget(logo: VISA, role: loc.experience_visa, content: loc.experience_visa_desc),
                        ExperienceWidget(logo: _winter ? CALSPAN_WHITE : CALSPAN_BLACK, role: loc.experience_calspan, content: loc.experience_calspan_desc),
                        ExperienceWidget(logo: COACHMEPLUS, role: loc.experience_coachmeplus, content: loc.experience_coachmeplus_desc),
                      ],
                    ),
                    MenuItem(
                      text: loc.projects,
                      onPressed: () {
                        if (_menuIndex == 2) {
                          _menuIndex = -1;
                        } else {
                          _menuIndex = 2;
                        }
                        setState(() {});
                      },
                      controller: projectsController,
                      previousController: _menuIndex == -1 ? null : expansionControllers[_menuIndex],
                      color: _menuIndex == 2 ? _jColors[_colorIndex] : secondaryColor,
                      children: [
                        ProjectsWidget(folder: PROJECTS, loc: loc),
                      ],
                    ),
                    MenuItem(
                      text: loc.photos,
                      onPressed: () {
                        if (_menuIndex == 3) {
                          _menuIndex = -1;
                        } else {
                          _menuIndex = 3;
                        }
                        setState(() {});
                      },
                      controller: photosController,
                      previousController: _menuIndex == -1 ? null : expansionControllers[_menuIndex],
                      color: _menuIndex == 3 ? _jColors[_colorIndex] : secondaryColor,
                      children: const [
                        StaggeredPhotoGridWidget(folder: PHOTOS, itemCount: 10),
                      ],
                    ),
                    const Spacer3(),
                  ]
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ExpansionTileController controller;
  final ExpansionTileController? previousController;
  final Color? color;
  final List<Widget> children;

  const MenuItem({required this.text, required this.onPressed, required this.controller, this.previousController, this.color, required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Spacer1(),
      Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Row(children: [SlideAnimation(
            onPressed: () {
              if (controller.isExpanded) {
                controller.collapse();
              } else {
                controller.expand();
              }
            },
            child: MenuText(text: text, color: color),
          ),]),
          enabled: false,
          controller: controller,
          shape: const Border(),
          trailing: const SizedBox(),
          onExpansionChanged: (value) {
            if (previousController != null) {
              previousController!.collapse();
            }
            onPressed();
          },
          children: children,
        ),
      ),
    ]);
  }
}

class SocialLink extends StatelessWidget {
  final String logo;
  final String link;
  final Color color;
  final AppLocalizations loc;

  const SocialLink({required this.logo, required this.link, required this.color, required this.loc, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onPressed: () async {
        final messenger = ScaffoldMessenger.of(context);
        try {
          await launchUrl(Uri.parse(link));
        } catch (e) {
          if (!context.mounted) return;
          messenger.showSnackBar(
            SnackBar(content: Text(loc.link_error(link))),
          );
        }
      },
      icon: Image.asset(logo, height: MediaQuery.of(context).size.height / 22, color: color),
    );
  }
}

class NameWidget extends StatelessWidget {
  final AppLocalizations loc;
  final VoidCallback onPressed;
  final Color textColor;
  final int colorIndex;

  const NameWidget({required this.loc, required this.onPressed, required this.textColor, required this.colorIndex, super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.displayLarge!;

    return SlideAnimation(
      onPressed: onPressed,
      child:  RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: loc.first_name, style: textStyle.copyWith(color: textColor)),
            TextSpan(text: loc.middle_name, style: textStyle.copyWith(color: _jColors[colorIndex])),
            TextSpan(text: loc.last_name, style: textStyle.copyWith(color: textColor)),
          ],
        ),
      ),
    );
  }
}