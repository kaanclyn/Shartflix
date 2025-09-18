import 'dart:ui';

import 'package:flutter/material.dart';

class GlassSearchBar extends StatelessWidget {
  const GlassSearchBar({super.key, this.onChanged});

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  onChanged: onChanged,
                  decoration: const InputDecoration(
                    hintText: 'Search movies, series... ',
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.search, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}


