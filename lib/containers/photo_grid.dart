import 'package:flutter/material.dart';
import 'package:flutter_starter/utils/common.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_starter/utils/constants.dart';

class SinglePhotoGridWidget extends StatelessWidget {
  final String folder;
  final int itemCount;
  final bool light;

  const SinglePhotoGridWidget({required this.folder, this.itemCount = 0, this.light = true, super.key});

  @override
  Widget build(BuildContext context) {
    return CenteredContainer(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 3 / 2.1,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return OpenableImageWidget(image: "image${index + 1}.jpeg", folder: folder, light: light);
        },
      ),
    );
  }
}

class StaggeredPhotoGridWidget extends StatelessWidget {
  final String folder;
  final int itemCount;
  final bool light;

  const StaggeredPhotoGridWidget({required this.folder, this.itemCount = 0, this.light = true, super.key});

  @override
  Widget build(BuildContext context) {
    return CenteredContainer(
      child: MasonryGridView.count(
        itemCount: itemCount,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          return OpenableImageWidget(image: "image${index + 1}.jpeg", folder: folder, light: light);
        },
      ),
    );
  }
}

class OpenableImageWidget extends StatelessWidget {
  final String image;
  final String folder;
  final bool light;

  const OpenableImageWidget({required this.image, required this.folder, this.light = true, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  child: Stack(
                    children: [
                      Image.asset(folder + HIGH_QUALITY + image, fit: BoxFit.cover),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: RoundButton(
                          text: "X",
                          textColor: light ? Colors.white : Colors.black,
                          backgroundColor: light ? Colors.black : Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Image.asset(
            folder + image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}