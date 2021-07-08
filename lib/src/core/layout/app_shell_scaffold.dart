import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/src/app/app.dart';
import 'package:recipe_book_flutter/src/core/layout/window_size_class.dart';
import 'package:recipe_book_flutter/src/core/localization/locale_controller.dart';
import 'package:recipe_book_flutter/src/core/localization/localization.dart';
import 'package:recipe_book_flutter/src/core/widgets/glass_panel.dart';
import 'package:recipe_book_flutter/src/features/auth/presentation/auth_controller.dart';
import 'package:recipe_book_flutter/src/features/auth/presentation/auth_dialog.dart';

class const AppShellScaffold({
  required final int selectedIndex,
  required final String title,
  required final Widget body,
  required final ValueChanged<int> onDestinationSelected,
  final Widget? floatingActionButton,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowWidthClass widthClass = AppBreakpoints.widthClassOf(context);
    final compact = widthClass == WindowWidthClass.compact;
    final bool desktop =
        MediaQuery.sizeOf(context).width >= AppBreakpoints.desktopNavigation;
    final destinations = [
      NavigationDestination(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home),
        label: context.l10n.navHome,
      ),
      NavigationDestination(
        icon: const Icon(Icons.restaurant_menu_outlined),
        selectedIcon: const Icon(Icons.restaurant_menu),
        label: context.l10n.navRecipes,
      ),
      NavigationDestination(
        icon: const Icon(Icons.favorite_border),
        selectedIcon: const Icon(Icons.favorite),
        label: context.l10n.navFavorites,
      ),
      NavigationDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: context.l10n.navProfile,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      appBar: _GlassAppBar(
        title: title,
        selectedIndex: selectedIndex,
        destinations: destinations,
        onDestinationSelected: onDestinationSelected,
      ),
      body: GlassBackground(
        child: compact || desktop
            ? body
            : Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                    child: GlassPanel(
                      borderRadius: BorderRadius.circular(30),
                      child: _Navigation(
                        selectedIndex: selectedIndex,
                        destinations: destinations,
                        onDestinationSelected: onDestinationSelected,
                      ),
                    ),
                  ),
                  Expanded(child: body),
                ],
              ),
      ),
      bottomNavigationBar: compact
          ? GlassPanel(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              blur: 28,
              child: NavigationBar(
                selectedIndex: selectedIndex,
                destinations: destinations,
                onDestinationSelected: onDestinationSelected,
              ),
            )
          : null,
      floatingActionButton: floatingActionButton,
    );
  }
}

class const _GlassAppBar({
  required final String title,
  required final int selectedIndex,
  required final List<NavigationDestination> destinations,
  required final ValueChanged<int> onDestinationSelected,
}) extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final bool desktop =
        MediaQuery.sizeOf(context).width >= AppBreakpoints.desktopNavigation;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(205),
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.primary.withAlpha(60),
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 12, 8),
              child: Row(
                children: [
                  DecoratedBox(
                    decoration: ShapeDecoration(
                      color: Theme.of(context).colorScheme.primary
                          .withAlpha(42),
                      shape: RoundedSuperellipseBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(9),
                      child: Icon(Icons.restaurant_menu, size: 20),
                    ),
                  ),
                  const SizedBox(width: 14),
                  if (desktop) ...[
                    Text(
                      context.l10n.appTitle,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(width: 28),
                    Expanded(
                      child: _DesktopNavigation(
                        selectedIndex: selectedIndex,
                        destinations: destinations,
                        onDestinationSelected: onDestinationSelected,
                      ),
                    ),
                  ] else
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  const _LocaleAction(),
                  _AuthAction(onDestinationSelected: onDestinationSelected),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class const _Navigation({
  required final int selectedIndex,
  required final List<NavigationDestination> destinations,
  required final ValueChanged<int> onDestinationSelected,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      leading: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 20),
        child: Icon(
          Icons.auto_awesome,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      destinations: destinations
          .map(
            (destination) => NavigationRailDestination(
              icon: destination.icon,
              selectedIcon: destination.selectedIcon,
              label: Text(destination.label),
            ),
          )
          .toList(growable: false),
    );
  }
}

class const _DesktopNavigation({
  required final int selectedIndex,
  required final List<NavigationDestination> destinations,
  required final ValueChanged<int> onDestinationSelected,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: destinations.indexed
          .map(
            (entry) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: _DesktopDestination(
                destination: entry.$2,
                selected: selectedIndex == entry.$1,
                onPressed: () => onDestinationSelected(entry.$1),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class const _DesktopDestination({
  required final NavigationDestination destination,
  required final bool selected,
  required final VoidCallback onPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color background = selected
        ? Theme.of(context).colorScheme.primary.withAlpha(54)
        : Colors.transparent;
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        backgroundColor: background,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      icon: selected ? destination.selectedIcon : destination.icon,
      label: Text(
        destination.label,
        style: TextStyle(fontWeight: selected ? FontWeight.w700 : null),
      ),
    );
  }
}

class const _LocaleAction() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LocaleController controller = LocaleScope.of(context);
    final isRussian = controller.locale.languageCode == 'ru';
    return IconButton(
      tooltip: context.l10n.switchLanguage,
      onPressed: () async {
        try {
          await controller.toggle();
        } on Object catch (error) {
          if (context.mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error.toString())));
          }
        }
      },
      icon: Text(
        isRussian ? '\u{1F1F7}\u{1F1FA}' : '\u{1F1FA}\u{1F1F8}',
        style: const TextStyle(fontSize: 22),
      ),
    );
  }
}

class const _AuthAction({
  required final ValueChanged<int> onDestinationSelected,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController auth = AuthScope.of(context);
    if (auth.status == AuthStatus.checking) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    if (!auth.isAuthenticated) {
      return TextButton.icon(
        onPressed: () => showAuthDialog(context),
        icon: const Icon(Icons.login),
        label: Text(context.l10n.signIn),
      );
    }
    return PopupMenuButton<String>(
      icon: const Icon(Icons.account_circle_outlined),
      onSelected: (value) async {
        try {
          if (value == 'profile') {
            onDestinationSelected(3);
          } else {
            await auth.logout();
            onDestinationSelected(0);
          }
        } on Object catch (error) {
          if (context.mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error.toString())));
          }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: 'profile', child: Text(context.l10n.navProfile)),
        PopupMenuItem(value: 'logout', child: Text(context.l10n.signOut)),
      ],
    );
  }
}
