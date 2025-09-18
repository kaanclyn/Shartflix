import 'dart:ui';

import 'package:flutter/material.dart';

import '../../home/presentation/home_page.dart';
import '../../movie/presentation/favorites_page.dart';
import '../../user/presentation/profile_page.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/localization/strings.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;
  final GlobalKey<FavoritesPageState> _favKey = GlobalKey<FavoritesPageState>();
  late final List<Widget> _tabs = <Widget>[
    const HomePage(),
    FavoritesPage(key: _favKey),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLocaleController.instance,
      builder: (BuildContext context, Widget? _) {
        final S t = S.of(AppLocaleController.instance.locale);
        return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: _tabs,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                currentIndex: _index,
                onTap: (int i) {
                  setState(() => _index = i);
                  if (i == 1) {
                    _favKey.currentState?.refresh();
                  }
                },
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), label: t.navHome),
                  BottomNavigationBarItem(icon: const Icon(Icons.favorite_outline), label: t.navFavorites),
                  BottomNavigationBarItem(icon: const Icon(Icons.person_outline), label: t.navProfile),
                ],
              ),
            ),
          ),
        ),
      ),
    );
      },
    );
  }
}


