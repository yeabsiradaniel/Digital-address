import 'package:flutter/cupertino.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Help & Support'),
      ),
      child: ListView(
        children: [
          const SizedBox(height: 20),
          CupertinoListSection.insetGrouped(
            header: const Text('FREQUENTLY ASKED QUESTIONS'),
            children: const [
              CupertinoListTile(
                title: Text('How do I find a property?'),
                subtitle: Text('Use the search bar on the Explore page to search by its unique Digital ID.'),
              ),
              CupertinoListTile(
                title: Text('How do I save a property?'),
                subtitle: Text('Tap the heart icon on a property\'s detail page or on the pop-up panel.'),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            header: const Text('CONTACT US'),
            children: [
              CupertinoListTile(
                title: const Text('Email Support'),
                leading: const Icon(CupertinoIcons.mail),
                onTap: () => _showSupportAlert(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSupportAlert(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Contact Support'),
        content: const Text('This would open your default email client to contact support@example.com.'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}