import 'package:flutter/material.dart';
import 'package:flutter_starter/containers/photo_grid.dart';
import 'package:flutter_starter/utils/common.dart';
import 'package:flutter_starter/model/theme_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class TextWidget extends StatelessWidget {
  final String text;

  const TextWidget({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      children: [SubtitleText(text: text, color: Provider.of<ThemeModel>(context).currentTheme.primaryColor)],
    );
  }
}

class ExperienceWidget extends StatelessWidget {
  final String logo;
  final String role;
  final String content;

  const ExperienceWidget({required this.logo, required this.role, required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Provider.of<ThemeModel>(context).currentTheme.primaryColor;

    return RoundedContainer(
      children: [
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.spaceBetween,
            children: [
              Image.asset(logo, height: 30, fit: BoxFit.cover),
              const Spacer1(),
              SubtitleText(text: role, color: primaryColor),
            ],
          ),
        ),
        const Spacer1(),
        BodyText(text: content, color: primaryColor),
      ],
    );
  }
}

class ProjectWidget extends StatelessWidget {
  final String image;
  final String folder;
  final String title;
  final String content;
  final AppLocalizations loc;
  final String? link;

  const ProjectWidget({
    required this.image,
    required this.folder,
    required this.title,
    required this.content,
    required this.loc,
    this.link,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeModel = Provider.of<ThemeModel>(context).currentTheme;
    Color textColor = themeModel.primaryColor;
    return RoundedContainer(
      children: [
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.spaceBetween,
            children: [
              SubtitleText(text: title, color: textColor),
              if (link != null)
                RoundButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    try {
                      await launchUrl(Uri.parse(link!));
                    } catch (e) {
                      if (!context.mounted) return;
                      messenger.showSnackBar(
                        SnackBar(content: Text(loc.link_error(link!))),
                      );
                    }
                  },
                  color: themeModel.primaryColor,
                  child: Icon(Icons.open_in_new_rounded, color: themeModel.secondaryHeaderColor),
                ),
            ],
          ),
        ),
        const Spacer1(),
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(child: Column(children: [
                OpenableImageWidget(image, folder: folder),
                const Spacer1(),
              ])),
              TextSpan(
                text: content,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProjectsWidget extends StatelessWidget {
  final String folder;
  final AppLocalizations loc;

  const ProjectsWidget({required this.folder, required this.loc, super.key});

  @override
  Widget build(BuildContext context) {
    List<String> projectTitles = [loc.project_1_title, loc.project_2_title];
    List<String> projectDescriptions = [loc.project_1_description, loc.project_2_description];
    List<String?> links = ["https://ljbalbach.github.io/Kite_Calculator/", null];
    int itemCount = projectTitles.length;

    final children = <Widget>[];
    for (var i = 0; i < itemCount; i++) {
      children.add(ProjectWidget(
        image: "image${i + 1}.jpeg",
        folder: folder,
        title: projectTitles[i],
        content: projectDescriptions[i],
        loc: loc,
        link: links[i],
      ));
    }
    return Column(children: children);
  }
}