import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../auth/data/auth_repository.dart';
import 'language_page.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/localization/strings.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _name;
  String? _email;
  String? _photoUrl;
  bool _busy = false;
  DateTime? _lastLoginAt;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _busy = true);
    try {
      final repo = AuthRepository();
      final user = await repo.profile();
      if (!mounted) return;
      setState(() {
        _name = user.name.isNotEmpty ? user.name : null;
        _email = user.email.isNotEmpty ? user.email : null;
        _photoUrl = user.photoUrl?.isNotEmpty == true ? user.photoUrl : null;
      });
      if ((_name == null || _email == null)) {
        final tokenUser = await repo.profileFromStoredToken();
        if (!mounted) return;
        setState(() {
          _name ??= tokenUser.name.isNotEmpty ? tokenUser.name : null;
          _email ??= tokenUser.email.isNotEmpty ? tokenUser.email : null;
          _photoUrl ??= tokenUser.photoUrl?.isNotEmpty == true ? tokenUser.photoUrl : null;
        });
      }
      if ((_name == null || _email == null)) {
        final cached = await repo.lastKnownUser();
        if (!mounted) return;
        if (cached != null) {
          setState(() {
            _name ??= cached.name.isNotEmpty ? cached.name : null;
            _email ??= cached.email.isNotEmpty ? cached.email : null;
            _photoUrl ??= cached.photoUrl?.isNotEmpty == true ? cached.photoUrl : null;
          });
        }
      }
      _lastLoginAt = await repo.getLastLoginAt();
    } catch (_) {
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickAndUpload() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (file == null) return;
    setState(() => _busy = true);
    try {
      final String url = await AuthRepository().uploadPhoto(filePath: file.path);
      if (!mounted) return;
      if (url.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Server didn't return a photo URL.")));
      }
      setState(() => _photoUrl = url.isNotEmpty ? url : file.path);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLocaleController.instance,
      builder: (BuildContext context, Widget? _) {
        final S t = S.of(AppLocaleController.instance.locale);
        return Scaffold(
          appBar: AppBar(title: Text(t.profile)),
          body: _busy
              ? const Center(child: CircularProgressIndicator.adaptive())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: <Widget>[
                Center(
                  child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 48,
                        backgroundImage: _photoUrl == null
                            ? null
                            : (_photoUrl!.startsWith('http')
                                ? NetworkImage(_photoUrl!) as ImageProvider
                                : FileImage(File(_photoUrl!))),
                        child: _photoUrl == null ? const Icon(Icons.person, size: 48) : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickAndUpload,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Center(child: Text(_name ?? '-', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18))),
                const SizedBox(height: 4),
                Center(child: Text(_email ?? '-', style: const TextStyle(color: Colors.white70))),
                const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(t.language),
                  subtitle: Text(AppLocaleController.instance.locale == AppLocale.tr ? t.turkish : t.english),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const LanguagePage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: Text(t.lastSignIn),
                  subtitle: Text(
                    _lastLoginAt == null
                        ? t.unknown
                        : _lastLoginAt!.toLocal().toString().split('.').first,
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Column(
                    children: <Widget>[
                      Text(t.rightsReserved, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(t.designByKaan, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                ),
                  ],
                ),
        );
      },
    );
  }
}


