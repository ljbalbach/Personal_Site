import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter/containers/photo_grid.dart';
import 'package:flutter_starter/utils/common.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final bool light;

  const TextWidget({required this.text, this.light = true, super.key});

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      light: light,
      children: [SubtitleText(text: text, color: light ? Colors.white : Colors.black)],
    );
  }
}

class ExperienceWidget extends StatelessWidget {
  final String logo;
  final String role;
  final String content;
  final bool light;

  const ExperienceWidget({required this.logo, required this.role, required this.content, this.light = true, super.key});

  @override
  Widget build(BuildContext context) {
    Color textColor = light ? Colors.white : Colors.black;

    return RoundedContainer(
      light: light,
      children: [
        Wrap(
          children: [
            Image.asset(logo, height: 30, fit: BoxFit.cover),
            const Spacer1(),
            SubtitleText(text: role, color: light ? Colors.white : Colors.black),
          ],
        ),
        const Spacer1(),
        BodyText(text: content, color: textColor),
      ],
    );
  }
}

class ProjectWidget extends StatelessWidget {
  final String image;
  final String folder;
  final String title;
  final String content;
  final bool light;
  final String? link;

  const ProjectWidget({
    required this.image,
    required this.folder,
    required this.title,
    required this.content,
    this.light = true,
    this.link,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = light ? Colors.white : Colors.black;
    return RoundedContainer(
      light: light,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SubtitleText(text: title, color: textColor),
            if (link != null)
              RoundButton(
                backgroundColor: textColor,
                onPressed: () async {
                    await launchUrl(Uri.parse(link!));
                  },
                child: Icon(Icons.open_in_new_rounded, color: light ? Colors.black : Colors.white),
              ),
          ],
        ),
        const Spacer1(),
        DropCapText(
          content,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(color: textColor),
          dropCap: DropCap(
            width: 300,
            height: 200,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: OpenableImageWidget(image, folder: folder, light: light),
            ),
          ),
        ),
      ],
    );
  }
}

class ProjectsWidget extends StatelessWidget {
  final String folder;
  final AppLocalizations loc;
  final int itemCount;
  final bool light;

  const ProjectsWidget({required this.folder, required this.loc, this.itemCount = 0, this.light = true, super.key});

  @override
  Widget build(BuildContext context) {
    List<String> projectTitles = [loc.project_1_title, loc.project_2_title];
    List<String> projectDescriptions = [loc.project_1_description, loc.project_2_description];
    List<String?> links = ["https://ljbalbach.github.io/Kite_Calculator/", null];

    final children = <Widget>[];
    for (var i = 0; i < itemCount; i++) {
      children.add(ProjectWidget(
        image: "image${i + 1}.jpeg",
        folder: folder,
        title: projectTitles[i],
        content: projectDescriptions[i],
        light: light,
        link: links[i],
      ));
    }
    return Column(children: children);
  }
}