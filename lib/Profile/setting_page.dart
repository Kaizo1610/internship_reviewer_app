import 'package:flutter/material.dart';
import 'update_password_page.dart'; 
import 'logout_confirmation_page.dart'; 

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: _darkModeEnabled ? Colors.grey[900] : Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _darkModeEnabled
                ? [Colors.grey[850]!, Colors.grey[900]!]
                : [Colors.deepPurple[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notifications Toggle
              _buildSettingTile(
                icon: Icons.notifications,
                title: 'Notifications',
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                  activeColor: Colors.deepPurple,
                ),
              ),
              const Divider(height: 20, color: Colors.grey),
              // Dark Mode Toggle
              _buildSettingTile(
                icon: Icons.dark_mode,
                title: 'Dark Mode',
                trailing: Switch(
                  value: _darkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      _darkModeEnabled = value;
                    });
                  },
                  activeColor: Colors.deepPurple,
                ),
              ),
              const Divider(height: 20, color: Colors.grey),
              // Update Password Option
              _buildSettingTile(
                icon: Icons.lock,
                title: 'Update Password',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UpdatePasswordPage(),
                    ),
                  );
                },
              ),
              const Divider(height: 20, color: Colors.grey),
              // Log Out Option
              _buildSettingTile(
                icon: Icons.logout,
                title: 'Log Out',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LogoutConfirmationPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: _darkModeEnabled ? Colors.white : Colors.deepPurple),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: _darkModeEnabled ? Colors.white : Colors.black87,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}