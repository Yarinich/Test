import 'package:flutter/material.dart';

class PopupMenu extends StatefulWidget {
  const PopupMenu({
    required this.onLogout,
    this.child,
    this.popupKey,
    this.onCanceled,
    super.key,
  });

  final Widget? child;
  final GlobalKey? popupKey;
  final VoidCallback? onCanceled;
  final VoidCallback onLogout;

  @override
  State<PopupMenu> createState() => PopupMenuState();
}

class PopupMenuState extends State<PopupMenu> {
  late final List<_PopupMenuItem> _menuItems = [
    _PopupMenuItem(
      title: const Text('Log out'),
      onTap: widget.onLogout,
      icon: Icons.logout_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<VoidCallback>(
      key: widget.popupKey,
      itemBuilder: (_) => _menuItems,
      onSelected: _onSelected,
      onCanceled: _onCanceled,
      child: widget.child,
    );
  }

  void _onSelected(VoidCallback menuItemCallback) {
    menuItemCallback();
    widget.onCanceled?.call();
  }

  void _onCanceled() {
    widget.onCanceled?.call();
  }
}

class _PopupMenuItem extends PopupMenuItem<VoidCallback> {
  _PopupMenuItem({
    Widget? title,
    IconData? icon,
    VoidCallback? onTap,
    super.key,
  }) : super(
          value: onTap,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon),
            title: title,
            key: key,
          ),
        );
}
