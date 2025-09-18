import 'package:flutter/material.dart';
import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/strings.dart';

class CategoryChips extends StatefulWidget {
  const CategoryChips({super.key, this.onChanged});

  final ValueChanged<String>? onChanged;

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  static const List<String> _keys = <String>['trending', 'action', 'scifi', 'drama', 'comedy'];
  List<String> _labelsFor(S t) => <String>[t.catTrending, t.catAction, t.catSciFi, t.catDrama, t.catComedy];
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLocaleController.instance,
      builder: (BuildContext context, Widget? _) {
        final S t = S.of(AppLocaleController.instance.locale);
        final List<String> _labels = _labelsFor(t);
        return SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int i) {
              final bool active = i == _selected;
              return GestureDetector(
                onTap: () {
                  setState(() => _selected = i);
                  widget.onChanged?.call(_keys[i]);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: active ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: active ? Theme.of(context).colorScheme.primary : Colors.white12,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _labels[i],
                    style: TextStyle(
                      color: active ? Colors.white : Colors.white70,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemCount: _labels.length,
          ),
        );
      },
    );
  }
}


