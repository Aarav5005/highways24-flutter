import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/user_model.dart';
import '../core/widgets/sos_floating_button.dart';
import '../core/theme/app_theme.dart';
import '../core/localization/app_localizations.dart';
import 'driver/driver_home_screen.dart';
import 'driver/trip_planner_screen.dart';
import 'driver/mechanic_request_screen.dart';
import 'driver/loyalty_screen.dart';
import 'dhaba/dhaba_dashboard_screen.dart';
import 'mechanic/mechanic_dashboard_screen.dart';
import 'auth/welcome_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _driverTabIndex = 0;

  final List<Widget> _driverScreens = const [
    DriverHomeScreen(),
    TripPlannerScreen(),
    MechanicRequestScreen(),
    LoyaltyScreen(),
  ];

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout / लॉगआउट'),
        content: const Text('Are you sure you want to logout from your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel / रद्द करें'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.sosRed, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (c) => const WelcomeScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.currentUser;
    final role = user.role;
    final loc = AppLocalizations(appState.appLocale);

    Widget bodyWidget;
    Widget? floatingActionButton;
    String appBarTitle;

    switch (role) {
      case UserRole.driver:
        appBarTitle = 'Highway Setu Driver';
        bodyWidget = IndexedStack(
          index: _driverTabIndex,
          children: _driverScreens,
        );
        floatingActionButton = const SOSFloatingButton();
        break;
      case UserRole.dhaba:
        appBarTitle = 'Dhaba Partner Portal';
        bodyWidget = const DhabaDashboardScreen();
        floatingActionButton = null;
        break;
      case UserRole.mechanic:
        appBarTitle = 'Mechanic Breakdown Hub';
        bodyWidget = const MechanicDashboardScreen();
        floatingActionButton = null;
        break;
      case UserRole.admin:
        appBarTitle = 'Highway Administrator';
        bodyWidget = const DriverHomeScreen();
        floatingActionButton = const SOSFloatingButton();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              role == UserRole.driver
                  ? Icons.local_shipping
                  : role == UserRole.dhaba
                      ? Icons.restaurant
                      : Icons.build,
              color: AppTheme.accentGold,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                appBarTitle,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          // Language Quick Selector Dropdown
          DropdownButton<String>(
            value: appState.appLocale.languageCode,
            dropdownColor: AppTheme.primaryNavy,
            underline: const SizedBox(),
            icon: const Icon(Icons.language, color: AppTheme.accentGold, size: 20),
            items: const [
              DropdownMenuItem(value: 'hi', child: Text('🇮🇳 हिन्दी', style: TextStyle(color: Colors.white, fontSize: 12))),
              DropdownMenuItem(value: 'en', child: Text('🇬🇧 Eng', style: TextStyle(color: Colors.white, fontSize: 12))),
              DropdownMenuItem(value: 'pa', child: Text('🇮🇳 ਪੰਜਾਬੀ', style: TextStyle(color: Colors.white, fontSize: 12))),
            ],
            onChanged: (val) {
              if (val != null) {
                appState.setLocale(Locale(val));
              }
            },
          ),
          const SizedBox(width: 6),
          Container(
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentGold,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              role.displayName,
              style: const TextStyle(
                color: AppTheme.primaryDark,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70),
            tooltip: 'Logout',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: bodyWidget,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: role == UserRole.driver
          ? BottomNavigationBar(
              currentIndex: _driverTabIndex,
              onTap: (idx) => setState(() => _driverTabIndex = idx),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppTheme.accentGold,
              unselectedItemColor: Colors.white70,
              backgroundColor: AppTheme.primaryDark,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: loc.tr('home'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.alt_route),
                  label: loc.tr('trip'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.build),
                  label: loc.tr('nearby_mechanics').split(' ').last,
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.stars),
                  label: 'इनाम / Rewards',
                ),
              ],
            )
          : null,
    );
  }
}
