import 'package:flutter/material.dart';

import 'package:scroll_experiments/motion_blur_scrollable.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scrollable Demo',
      home: Scaffold(
        body: Content(),
      ),
    );
  }
}

class Content extends StatelessWidget {
  const Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 600,
        child: ScrollableBlur(
          child: ColoredBox(
            color: const Color(0xFFFFFFFF),
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                if (index % 5 == 0) {
                  return const Title(
                    child: Text('Oslo photos'),
                  );
                }
                return RandomOsloPhoto(
                  key: ValueKey(index),
                  index: index,
                );
              },
              itemCount: 100,
            ),
          ),
        ),
      ),
    );
  }
}

class RandomOsloPhoto extends StatefulWidget {
  const RandomOsloPhoto({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<RandomOsloPhoto> createState() => _RandomOsloPhotoState();
}

class _RandomOsloPhotoState extends State<RandomOsloPhoto>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Image.network(
        'https://source.unsplash.com/800x600/?vikings,oslo,${widget.index}',
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Title extends StatelessWidget {
  const Title({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return DefaultTextStyle.merge(
      style: theme.headline1!.merge(const TextStyle(
        fontWeight: FontWeight.w900,
        color: Color(0xFF000000),
        letterSpacing: -12,
        height: 0.9
      ),),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: child,
      ),
    );
  }
}
