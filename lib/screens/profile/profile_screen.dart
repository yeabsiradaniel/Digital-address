import 'package:flutter/cupertino.dart';
import 'package:digital_addressing_app/screens/login/login_screen.dart';
import 'package:digital_addressing_app/screens/profile/edit_profile_screen.dart';
import 'package:digital_addressing_app/screens/settings/settings_screen.dart';
import 'package:digital_addressing_app/screens/help/help_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = {'name': 'Beti21', 'email': 'beti21@gmail.com', 'avatarUrl': 'https://i.pravatar.cc/150?img=12'};

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Profile')),
      child: ListView(
        children: [
          const SizedBox(height: 20),
          CupertinoListSection.insetGrouped(
            children: [
              CupertinoListTile(
                leading: ClipRRect(borderRadius: BorderRadius.circular(22.0), child: Image.network(user['avatarUrl']!, width: 44.0, height: 44.0, fit: BoxFit.cover)),
                title: Text(user['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(user['email']!),
                trailing: const CupertinoListTileChevron(),
                onTap: () => Navigator.of(context).push(CupertinoPageRoute(builder: (_) => const EditProfileScreen())),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            header: const Text('SAVED PLACES'),
            children: const [
              CupertinoListTile(title: Text('Home'), trailing: CupertinoListTileChevron()),
              CupertinoListTile(title: Text('Work'), trailing: CupertinoListTileChevron()),
            ],
          ),
          CupertinoListSection.insetGrouped(
            children: [
              CupertinoListTile(
                title: const Text('Settings'),
                leading: const Icon(CupertinoIcons.settings),
                trailing: const CupertinoListTileChevron(),
                onTap: () => Navigator.of(context).push(CupertinoPageRoute(builder: (_) => const SettingsScreen())),
              ),
              CupertinoListTile(
                title: const Text('Help & Support'),
                leading: const Icon(CupertinoIcons.question_circle),
                trailing: const CupertinoListTileChevron(),
                onTap: () => Navigator.of(context).push(CupertinoPageRoute(builder: (_) => const HelpScreen())),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            children: [
              CupertinoListTile(
                title: const Text('Log Out', style: TextStyle(color: CupertinoColors.destructiveRed)),
                leading: const Icon(CupertinoIcons.square_arrow_left, color: CupertinoColors.destructiveRed),
                onTap: () => _showLogoutConfirmation(context),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Log Out'),
            onPressed: () {
              // Clear navigation stack and go to LoginScreen
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                CupertinoPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}