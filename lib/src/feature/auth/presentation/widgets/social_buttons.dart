import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/widgets/modern_dialog.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  void _showMock(BuildContext context, String provider) {
    showModernInfoDialog(context, title: 'Info', message: '$provider button tapped (mock).');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _IconButton(
          asset: 'assets/images/google.svg.svg',
          onTap: () => _showMock(context, 'Google'),
        ),
        const SizedBox(width: 12),
        _IconButton(
          asset: 'assets/images/facebook.svg.svg',
          onTap: () => _showMock(context, 'Facebook'),
        ),
        const SizedBox(width: 12),
        _IconButton(
          asset: 'assets/images/x.svg.svg',
          onTap: () => _showMock(context, 'X/Twitter'),
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.asset, required this.onTap});
  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Ink(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            asset,
            width: 20,
            height: 20,
          ),
        ),
      ),
    );
  }
}

