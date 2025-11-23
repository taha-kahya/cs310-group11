import 'package:flutter/material.dart';
import 'package:locai/utils/colors.dart';
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
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
      )
          : null,
      title: Text(
        title,
        style: AppTextStyles.heading,
      ),
      actions: showMenu
          ? [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: onMenu ??
                    () {
                  final scaffoldState = Scaffold.maybeOf(context);
                  scaffoldState?.openEndDrawer();
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
