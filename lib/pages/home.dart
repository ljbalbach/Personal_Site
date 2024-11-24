import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_starter/containers/default_container.dart';
import 'package:flutter_starter/containers/photo_grid.dart';
import 'package:flutter_starter/containers/rounded_text_container.dart';
import 'package:flutter_starter/utils/common.dart';
import 'package:flutter_starter/utils/constants.dart';
import 'package:flutter_svg/svg.dart';
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
  bool winter = true;
  bool preloadWinter = true;
  bool monoTone = false;

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
        winter = !winter;
        setState(() {});
      }
    });
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
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
    var loc = AppLocalizations.of(context);
    Color textColor = winter ? Colors.black : Colors.white;
    List<ExpansionTileController> expansionControllers = [aboutController, experienceController, projectsController, photosController];

    return DefaultContainer(
      lightMode: winter,
      background: Stack(
        children: [
          if (!preloadWinter || !winter)
            Opacity(
              opacity: !monoTone && !winter ? 1 : 0,
              child: Image.asset(
                SUMMER,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          if (preloadWinter || winter)
            Opacity(
              opacity: !monoTone && winter ? 1 : 0,
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
      bottomLeft: monoTone ? Container(
        decoration: BoxDecoration(
          color: winter ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(children: [
          SocialLink(logo: GITHUB, link: "https://github.com/ljbalbach", color: textColor),
          SocialLink(logo: LINKEDIN, link: "https://www.linkedin.com/in/lucas-balbach-950002108/", color: textColor),
        ]),
      ) : null,
      bottomRight: GestureDetector(
        onTap: () {
          preloadWinter = !preloadWinter;
          setState(() {});

          double endRotation = winter ? 7 * pi : 8 * pi; // 5.5 for upside down, 6.5 for right side up
          _seasonsImageRotationAnimation = Tween<double>(begin: winter ? 0 : pi, end: endRotation).animate(
            CurvedAnimation(parent: _animationController, curve: Curves.easeOut)
          );
          _animationController.reset();
          _animationController.forward();
          setState(() {});
        },
        child: SizedBox(
          width: 150,
          height: 150,
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
          if (winter && !monoTone) const Snowfall(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NameWidget(
                  loc: loc,
                  onPressed: () {
                    monoTone = !monoTone;
                    if (!monoTone) {
                      _menuIndex = -1;
                    }
                    setState(() {});
                  },
                  textColor: textColor,
                  colorIndex: _colorIndex,
                ),
                if (monoTone) Column(
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
                      color: _menuIndex == 0 ? _jColors[_colorIndex] : textColor,
                      children: [
                        TextWidget(text: loc.about_description, light: winter),
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
                      color: _menuIndex == 1 ? _jColors[_colorIndex] : textColor,
                      children: [
                        ExperienceWidget(logo: VISA, role: loc.experience_visa, content: loc.experience_visa_desc, light: winter),
                        ExperienceWidget(logo: winter ? CALSPAN_WHITE : CALSPAN_BLACK, role: loc.experience_calspan, content: loc.experience_calspan_desc, light: winter),
                        ExperienceWidget(logo: COACHMEPLUS, role: loc.experience_coachmeplus, content: loc.experience_coachmeplus_desc, light: winter),
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
                      color: _menuIndex == 2 ? _jColors[_colorIndex] : textColor,
                      children: [
                        ProjectsWidget(folder: PROJECTS, itemCount: 2, loc: loc, light: winter),
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
                      color: _menuIndex == 3 ? _jColors[_colorIndex] : textColor,
                      children: [
                        StaggeredPhotoGridWidget(folder: PHOTOS, itemCount: 10, light: winter),
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

  const SocialLink({required this.logo, required this.link, required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: () async {
        await launchUrl(Uri.parse(link));
      },
      icon: SvgPicture.asset(logo, width: 40, colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
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
    return SlideAnimation(
      onPressed: onPressed,
      child:  RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: loc.first_name, style: Theme.of(context).textTheme.displayLarge!.copyWith(color: textColor)),
            TextSpan(text: loc.middle_name, style: Theme.of(context).textTheme.displayLarge!.copyWith(color: _jColors[colorIndex])),
            TextSpan(text: loc.last_name, style: Theme.of(context).textTheme.displayLarge!.copyWith(color: textColor)),
          ],
        ),
      ),
    );
  }
}

class Snowfall extends StatefulWidget {
  const Snowfall({super.key});

  @override
  SnowfallState createState() => SnowfallState();
}

class SnowfallState extends State<Snowfall> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final List<Snowflake> _snowflakes = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_snowflakes.isEmpty) {
      for (int i = 0; i < 150; i++) { // Increased snowflakes count
        _snowflakes.add(Snowflake(
          x: Random().nextInt((MediaQuery.of(context).size.width.toInt() * 1.3).round()) + 0.0,
          y: -i * 10,
          size: 2.0 + Random().nextInt(5), // Reduced max size
          speed: 0.5 + Random().nextDouble(),
        ));
      }
    }
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: SnowfallPainter(_snowflakes),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        );
      },
    );
  }
}

class Snowflake {
  double x;
  double y;
  double size;
  double speed;

  Snowflake({required this.x, required this.y, required this.size, required this.speed});

  void update() {
    x -= speed;
    y += speed * 2;
  }
}

class SnowfallPainter extends CustomPainter {
  final List<Snowflake> _snowflakes;

  SnowfallPainter(this._snowflakes);

  @override
  void paint(Canvas canvas, Size size) {
    for (var snowflake in _snowflakes) {
      snowflake.update();
      if (snowflake.x < 0 || snowflake.y > size.height) {
        snowflake.x = Random().nextInt((size.width.toInt() * 1.3).round()) + 0.0;
        snowflake.y = Random().nextInt(100) * -1.0;
      }
      canvas.drawCircle(
        Offset(snowflake.x, snowflake.y),
        snowflake.size,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}