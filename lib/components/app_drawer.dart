import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spectrum_app/providers/theme_provider.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Student',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: currentRoute == '/',
            onTap: () {
              Navigator.pop(context);
              context.push('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            selected: currentRoute == '/about',
            onTap: () {
              Navigator.pop(context);
              context.push('/about');
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_support),
            title: const Text('Contact'),
            selected: currentRoute == '/contact',
            onTap: () {
              Navigator.pop(context);
              context.push('/contact');
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            title: Text(
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? 'Light Mode'
                  : 'Dark Mode',
            ),
            onTap: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}
