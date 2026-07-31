import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../models/user_model.dart';
import '../theme/app_theme.dart';

class RoleSwitcherBanner extends StatelessWidget {
  const RoleSwitcherBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currentRole = appState.currentUser.role;

    return Container(
      color: AppTheme.primaryDark,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const Icon(Icons.swap_horiz, color: AppTheme.accentGold, size: 18),
            const SizedBox(width: 6),
            const Text(
              'Role:',
              style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: UserRole.values.map((role) {
                    if (role == UserRole.admin) return const SizedBox.shrink();
                    final isSelected = role == currentRole;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(
                          role.displayName,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppTheme.primaryDark : Colors.white,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppTheme.accentGold,
                        backgroundColor: Colors.white12,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onSelected: (selected) {
                          if (selected) {
                            appState.switchUserRole(role);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
