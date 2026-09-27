import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'brand.dart';

/// Local login credentials. The defaults are kept for first launch; subsequent
/// changes are persisted locally on the device/browser and do not affect the
/// Firestore sync data.
Map<String, String> kUserPasswords = <String, String>{
  'Arif': '1111',
  'Nisar': '2402',
  'Haroon': '2403',
  'Mushtaq': '2404',
  'Rameez': '2405',
  'Shafat': '2406',
  'Yasir': '2407',
};

String kSuperuserPassword = '9906';
String kAdminPassword = '1212';
String? currentUsername;

bool verifyUserPassword(String username, String password) =>
    kUserPasswords[username] == password;

bool verifySuperuserPassword(String password) => password == kSuperuserPassword;
bool verifyAdminPassword(String password) => password == kAdminPassword;

Future<void> initializeSecurity() async {
  final prefs = await SharedPreferences.getInstance();
  final storedUsers = prefs.getString('aabm_user_passwords');
  if (storedUsers != null && storedUsers.isNotEmpty) {
    try {
      final decoded = jsonDecode(storedUsers);
      if (decoded is Map) {
        final loaded = <String, String>{};
        decoded.forEach((key, value) {
          if (key is String && value is String && key.trim().isNotEmpty) {
            loaded[key.trim()] = value;
          }
        });
        if (loaded.isNotEmpty) kUserPasswords = loaded;
      }
    } catch (_) {
      // Keep safe defaults if the stored credentials are malformed.
    }
  }
  final storedSuperuser = prefs.getString('aabm_superuser_password');
  if (storedSuperuser != null && RegExp(r'^\d{4,}$').hasMatch(storedSuperuser)) {
    kSuperuserPassword = storedSuperuser;
  }
  final storedAdmin = prefs.getString('aabm_admin_password');
  if (storedAdmin != null && RegExp(r'^\d{4,}$').hasMatch(storedAdmin)) {
    kAdminPassword = storedAdmin;
  }
}

Future<void> _persistSecurity() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('aabm_user_passwords', jsonEncode(kUserPasswords));
  await prefs.setString('aabm_superuser_password', kSuperuserPassword);
  await prefs.setString('aabm_admin_password', kAdminPassword);
}

Future<void> saveUserPassword(String username, String password) async {
  kUserPasswords[username.trim()] = password.trim();
  await _persistSecurity();
}

Future<void> removeUserPassword(String username) async {
  kUserPasswords.remove(username);
  await _persistSecurity();
}

Future<void> saveSuperuserPassword(String password) async {
  kSuperuserPassword = password.trim();
  await _persistSecurity();
}

Future<void> saveAdminPassword(String password) async {
  kAdminPassword = password.trim();
  await _persistSecurity();
}

Future<bool> requireAdminPassword(
  BuildContext context, {
  String title = 'Admin Password Required',
  String message = 'Enter the separate Admin Password to continue.',
}) async {
  final ok = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _AdminPasswordDialog(title: title, message: message),
  );
  return ok == true;
}

class _AdminPasswordDialog extends StatefulWidget {
  final String title;
  final String message;
  const _AdminPasswordDialog({required this.title, required this.message});
  @override
  State<_AdminPasswordDialog> createState() => _AdminPasswordDialogState();
}

class _AdminPasswordDialogState extends State<_AdminPasswordDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!verifyAdminPassword(_controller.text.trim())) {
      if (mounted) setState(() => _error = 'Incorrect Admin Password.');
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.message),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            obscureText: true,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: 'Admin Password',
              errorText: _error,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
        FilledButton(onPressed: _submit, child: const Text('Continue')),
      ],
    );
  }
}

Future<bool> requireSuperuserPassword(
  BuildContext context, {
  String title = 'Superuser Password Required',
  String message = 'Enter the separate superuser password to continue.',
}) async {
  final ok = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _SuperuserPasswordDialog(title: title, message: message),
  );
  return ok == true;
}

class _SuperuserPasswordDialog extends StatefulWidget {
  final String title;
  final String message;
  const _SuperuserPasswordDialog({required this.title, required this.message});

  @override
  State<_SuperuserPasswordDialog> createState() => _SuperuserPasswordDialogState();
}

class _SuperuserPasswordDialogState extends State<_SuperuserPasswordDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!verifySuperuserPassword(_controller.text.trim())) {
      if (mounted) setState(() => _error = 'Incorrect superuser password.');
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.message),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: 'Superuser Password',
              errorText: _error,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
        FilledButton(onPressed: _submit, child: const Text('Continue')),
      ],
    );
  }
}

Future<bool> requestEditPassword(BuildContext context) =>
    requireSuperuserPassword(context, title: 'Authorize Edit');

class LoginPage extends StatefulWidget {
  final VoidCallback onSuccess;
  const LoginPage({super.key, required this.onSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _user = kUserPasswords.keys.first;
  final _password = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  void _login() {
    if (verifyUserPassword(_user, _password.text.trim())) {
      currentUsername = _user;
      widget.onSuccess();
    } else {
      setState(() => _error = 'Incorrect username/password.');
    }
  }

  Future<void> _manageUsers() async {
    final ok = await requireSuperuserPassword(
      context,
      title: 'Manage Users & Passwords',
      message: 'Superuser authorization is required to add, edit or remove users and manage system passwords.',
    );
    if (!mounted || !ok) return;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UserManagementPage()));
    if (!mounted) return;
    final users = kUserPasswords.keys.toList()..sort();
    if (users.isNotEmpty && !users.contains(_user)) _user = users.first;
    setState(() {});
  }

  Future<void> _changeAdminPassword() async {
    final old = TextEditingController();
    final next = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Admin Password'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: old, obscureText: true, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Current Admin Password', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: next, obscureText: true, maxLength: 4, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'New 4-digit Admin Password', border: OutlineInputBorder())),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () {
            if (!verifyAdminPassword(old.text.trim()) || !RegExp(r'^\d{4}$').hasMatch(next.text.trim())) return;
            Navigator.pop(context, next.text.trim());
          }, child: const Text('Change')),
        ],
      ),
    );
    old.dispose();
    next.dispose();
    if (result == null) return;
    await saveAdminPassword(result);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Admin password changed.')));
  }

  @override
  Widget build(BuildContext context) {
    final users = kUserPasswords.keys.toList()..sort();
    if (users.isNotEmpty && !users.contains(_user)) _user = users.first;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const BrandLogo(size: 105),
                    const SizedBox(height: 14),
                    const Text('AL-AMIN BAITUL MAAL', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: kBrandGreen)),
                    const SizedBox(height: 6),
                    const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      initialValue: users.contains(_user) ? _user : null,
                      decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
                      items: users.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                      onChanged: (v) { if (v != null) setState(() { _user = v; _error = null; }); },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => _login(),
                      decoration: InputDecoration(labelText: '4-digit Password', errorText: _error, border: const OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(width: double.infinity, height: 50, child: FilledButton(onPressed: users.isEmpty ? null : _login, child: const Text('LOGIN'))),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: _manageUsers,
                      icon: const Icon(Icons.manage_accounts_outlined),
                      label: const Text('Manage Users & Passwords'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  Future<void> _editUser([String? existing]) async {
    final name = TextEditingController(text: existing ?? '');
    final password = TextEditingController(text: existing == null ? '' : kUserPasswords[existing] ?? '');
    final result = await showDialog<List<String>>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? 'Add User' : 'Edit User'),
        content: SizedBox(
          width: 380,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'User name', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: password, maxLength: 4, keyboardType: TextInputType.number, obscureText: true, decoration: const InputDecoration(labelText: '4-digit password', border: OutlineInputBorder())),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () {
            final n = name.text.trim();
            final pw = password.text.trim();
            if (n.isEmpty || !RegExp(r'^\d{4}$').hasMatch(pw)) return;
            Navigator.pop(context, [n, pw]);
          }, child: const Text('Save')),
        ],
      ),
    );
    name.dispose();
    password.dispose();
    if (!mounted || result == null) return;
    final newName = result[0];
    if (existing != null && existing != newName) await removeUserPassword(existing);
    await saveUserPassword(newName, result[1]);
    if (mounted) setState(() {});
  }

  Future<void> _removeUser(String username) async {
    if (kUserPasswords.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('At least one user must remain.')));
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove User'),
        content: Text('Remove login user "$username"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Remove')),
        ],
      ),
    );
    if (ok == true) {
      await removeUserPassword(username);
      if (mounted) setState(() {});
    }
  }

  Future<void> _changeSuperuser() async {
    final old = TextEditingController();
    final next = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Superuser Password'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: old, obscureText: true, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Current Superuser Password', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: next, obscureText: true, maxLength: 4, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'New 4-digit password', border: OutlineInputBorder())),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () {
            if (!verifySuperuserPassword(old.text.trim()) || !RegExp(r'^\d{4}$').hasMatch(next.text.trim())) return;
            Navigator.pop(context, next.text.trim());
          }, child: const Text('Change')),
        ],
      ),
    );
    old.dispose();
    next.dispose();
    if (result == null) return;
    await saveSuperuserPassword(result);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Superuser password changed.')));
  }

  Future<void> _changeAdminPassword() async {
    final old = TextEditingController();
    final next = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Admin Password'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: old, obscureText: true, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Current Admin Password', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: next, obscureText: true, maxLength: 4, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'New 4-digit Admin Password', border: OutlineInputBorder())),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () {
            if (!verifyAdminPassword(old.text.trim()) || !RegExp(r'^\d{4}$').hasMatch(next.text.trim())) return;
            Navigator.pop(context, next.text.trim());
          }, child: const Text('Change')),
        ],
      ),
    );
    old.dispose();
    next.dispose();
    if (result == null) return;
    await saveAdminPassword(result);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Admin password changed.')));
  }

  @override
  Widget build(BuildContext context) {
    final users = kUserPasswords.keys.toList()..sort();
    return Scaffold(
      appBar: AppBar(title: const Text('User & Password Management')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(children: [
              Row(children: [
                Expanded(child: Text('Login Users', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: kBrandGreen))),
                FilledButton.icon(onPressed: () => _editUser(), icon: const Icon(Icons.person_add_alt_1), label: const Text('Add User')),
              ]),
              const SizedBox(height: 10),
              Expanded(
                child: Card(
                  child: ListView.separated(
                    itemCount: users.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final user = users[i];
                      return ListTile(
                        leading: CircleAvatar(child: Text(user[0].toUpperCase())),
                        title: Text(user, style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: const Text('Password is stored locally and hidden'),
                        trailing: Wrap(spacing: 4, children: [
                          IconButton(tooltip: 'Edit password/name', onPressed: () => _editUser(user), icon: const Icon(Icons.edit_outlined)),
                          IconButton(tooltip: 'Remove user', onPressed: () => _removeUser(user), icon: const Icon(Icons.delete_outline)),
                        ]),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: _changeSuperuser, icon: const Icon(Icons.admin_panel_settings_outlined), label: const Text('Change Superuser Password'))),
              const SizedBox(height: 8),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: _changeAdminPassword, icon: const Icon(Icons.password_outlined), label: const Text('Change Admin Password'))),
            ]),
          ),
        ),
      ),
    );
  }
}
