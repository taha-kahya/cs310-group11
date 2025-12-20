import 'package:flutter/material.dart';
import 'package:locai/utils/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final bool showMenu;
  final VoidCallback? onBack;
  final VoidCallback? onMenu;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.showMenu = true,
    this.onBack,
    this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor:
      theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,

      leading: showBack
          ? IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: theme.iconTheme.color,
        ),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
      )
          : null,

      title: Text(
        title,
        style: AppTextStyles.subheading.copyWith(
          color: theme.textTheme.titleLarge?.color,
        ),
      ),

      actions: showMenu
          ? [
        Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: theme.iconTheme.color,
            ),
            onPressed: onMenu ??
                    () {
                  Scaffold.maybeOf(context)?.openEndDrawer();
                },
          ),
        ),
      ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
