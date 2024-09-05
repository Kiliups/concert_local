import 'package:flutter/material.dart';

class ImageAppBar extends StatelessWidget {
  Widget title;
  String? imageUrl;

  ImageAppBar({super.key, required this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(8),
        centerTitle: true,
        title: title,
        background: imageUrl != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(1),
                          Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.1)
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox(),
      ),
    );
  }
}
