import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../movie/presentation/detail_page.dart';

class PosterCard extends StatefulWidget {
  const PosterCard({super.key, required this.movieId, required this.imageUrl, required this.title});

  final String movieId;
  final String imageUrl;
  final String title;

  @override
  State<PosterCard> createState() => _PosterCardState();
}

class _PosterCardState extends State<PosterCard> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => DetailPage(movieId: widget.movieId, imageUrl: widget.imageUrl, title: widget.title),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 2/3,
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (BuildContext _, String __) => Container(
                    color: Colors.white10,
                    child: const Center(child: Icon(Icons.image_outlined, color: Colors.white30)),
                  ),
                  errorWidget: (BuildContext _, String __, Object ___) => Container(
                    color: Colors.white10,
                    child: const Center(child: Icon(Icons.broken_image_outlined, color: Colors.white30)),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Colors.transparent, Colors.black.withOpacity(0.6)],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


