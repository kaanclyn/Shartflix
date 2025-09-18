import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HeroBanner extends StatefulWidget {
  const HeroBanner({super.key});

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  final PageController _controller = PageController(viewportFraction: 0.9);
  int _index = 0;
  final List<String> _images = <String>[
    // Known working samples
    'https://image.tmdb.org/t/p/w780/9Gtg2DzBhmYamXBS1hKAhiwbBKS.jpg',
    'https://image.tmdb.org/t/p/w780/ruU54gL1t6ZzGqH0hVx8vZp3Eop.jpg',
    'https://image.tmdb.org/t/p/w780/8YFL5QQVPy3AgrEQxNYVSgiPEbe.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (int i) => setState(() => _index = i),
            itemCount: _images.length,
            itemBuilder: (BuildContext context, int i) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  double value = 1.0;
                  if (_controller.position.haveDimensions) {
                    final double page = (_controller.page ?? _controller.initialPage.toDouble());
                    value = (1 - ((page - i).abs() * 0.1)).clamp(0.9, 1.0);
                  }
                  return Transform.scale(scale: value, child: child);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: _images[i],
                        fit: BoxFit.cover,
                        errorWidget: (BuildContext _, String __, Object ___) => Container(
                          color: Colors.white10,
                          child: const Center(child: Icon(Icons.movie, size: 32)),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[Colors.transparent, Colors.black.withOpacity(0.35)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(_images.length, (int i) {
            final bool active = i == _index;
            return Container(
              width: active ? 10 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: active ? Colors.white : Colors.white24,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}


