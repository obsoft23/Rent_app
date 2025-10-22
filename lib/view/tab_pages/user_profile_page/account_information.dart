import 'package:flutter/material.dart';

class AccountInformationPage extends StatelessWidget {
  const AccountInformationPage({
    super.key,
    required this.user,
    this.onEditProfile,
    this.onDeleteAccount,
  });

  final AccountInfo user;
  final VoidCallback? onEditProfile;
  final Future<void> Function()? onDeleteAccount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final error = theme.colorScheme.error;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account information'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Header(user: user),
            const SizedBox(height: 16),
            _InfoCard(
              leading: const Icon(Icons.mail_outline),
              title: 'Email',
              subtitle: user.email,
            ),
            if (user.phone != null && user.phone!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _InfoCard(
                leading: const Icon(Icons.phone_outlined),
                title: 'Phone',
                subtitle: user.phone!,
              ),
            ],
            if (user.joinedAt != null) ...[
              const SizedBox(height: 8),
              _InfoCard(
                leading: const Icon(Icons.calendar_today_outlined),
                title: 'Joined',
                subtitle: _formatDate(user.joinedAt!),
              ),
            ],
            const SizedBox(height: 24),
            // Primary action: Edit profile
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit profile'),
                onPressed: onEditProfile ?? () => _defaultEdit(context),
              ),
            ),
            const SizedBox(height: 8),
            // Destructive action: Delete account (clear visual distinction)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: Icon(Icons.delete_forever_outlined, color: error),
                label: Text(
                  'Delete account',
                  style: TextStyle(color: error, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: error),
                  backgroundColor: error.withOpacity(0.06),
                ),
                onPressed: () async {
                  final confirmed = await _confirmDelete(context);
                  if (confirmed) {
                    if (onDeleteAccount != null) {
                      await onDeleteAccount!();
                    } else {
                      _defaultDelete(context);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime dt) {
    // Simple human-readable date. Replace with intl if you prefer localization.
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final theme = Theme.of(context);
    final error = theme.colorScheme.error;
    final controller = TextEditingController();
    bool canDelete = false;

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            return StatefulBuilder(
              builder: (ctx, setState) {
                return AlertDialog(
                  title: const Text('Delete account'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'This action is permanent. All your data may be removed and cannot be recovered.',
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Type DELETE to confirm',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller,
                        autofocus: true,
                        onChanged: (v) {
                          setState(() => canDelete = v.trim().toUpperCase() == 'DELETE');
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'DELETE',
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.delete_forever_outlined, color: canDelete ? error : null),
                      label: Text(
                        'Delete',
                        style: TextStyle(
                          color: canDelete ? error : theme.disabledColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: canDelete ? () => Navigator.of(ctx).pop(true) : null,
                    ),
                  ],
                );
              },
            );
          },
        ) ??
        false;
  }

  void _defaultEdit(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit profile tapped')),
    );
  }

  void _defaultDelete(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account deletion requested')),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.user});

  final AccountInfo user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = _initials(user.fullName);

    return Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
          foregroundColor: theme.colorScheme.primary,
          backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
              ? NetworkImage(user.avatarUrl!)
              : null,
          child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
              ? Text(initials, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullName,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodySmall?.color),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    final first = parts[0][0];
    final second = parts.length > 1 ? parts[1][0] : '';
    return (first + second).toUpperCase();
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.leading,
    required this.title,
    required this.subtitle,
  });

  final Widget leading;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: leading,
        title: Text(title, style: theme.textTheme.labelLarge),
        subtitle: Text(subtitle),
      ),
    );
  }
}

// Simple data holder. Replace with your app's user model.
class AccountInfo {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final DateTime? joinedAt;

  const AccountInfo({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.joinedAt,
  });

  AccountInfo copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? avatarUrl,
  }) {
    return AccountInfo(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      joinedAt: joinedAt,
    );
  }
}