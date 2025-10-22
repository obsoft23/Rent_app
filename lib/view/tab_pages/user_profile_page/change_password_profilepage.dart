import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePasswordProfilePage extends StatefulWidget {
  const ChangePasswordProfilePage({
    Key? key,
    this.onSubmit,
    this.title = 'Change Password',
  }) : super(key: key);

  /// Optional callback to integrate with your auth layer.
  /// If not provided, a demo no-op implementation is used.
  final Future<void> Function(String currentPassword, String newPassword)? onSubmit;

  final String title;

  static Route<void> route({
    Future<void> Function(String currentPassword, String newPassword)? onSubmit,
    String title = 'Change Password',
  }) {
    return MaterialPageRoute(
      builder: (_) => ChangePasswordProfilePage(onSubmit: onSubmit, title: title),
    );
  }

  @override
  State<ChangePasswordProfilePage> createState() => _ChangePasswordProfilePageState();
}

class _ChangePasswordProfilePageState extends State<ChangePasswordProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  final _currentNode = FocusNode();
  final _newNode = FocusNode();
  final _confirmNode = FocusNode();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool _isSubmitting = false;
  double _passwordStrength = 0;

  @override
  void initState() {
    super.initState();
    _newCtrl.addListener(_recomputeStrength);
    _confirmCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    _currentNode.dispose();
    _newNode.dispose();
    _confirmNode.dispose();
    super.dispose();
  }

  void _recomputeStrength() {
    setState(() {
      _passwordStrength = _computeStrength(_newCtrl.text);
    });
  }

  double _computeStrength(String value) {
    if (value.isEmpty) return 0;
    int score = 0;
    final lengthOK = value.length >= 8;
    final hasLower = RegExp(r'[a-z]').hasMatch(value);
    final hasUpper = RegExp(r'[A-Z]').hasMatch(value);
    final hasDigit = RegExp(r'\d').hasMatch(value);
    final hasSpecial = RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-\[\]\\;/+=~`]').hasMatch(value);

    if (lengthOK) score++;
    if (hasLower && hasUpper) score++;
    if (hasDigit) score++;
    if (hasSpecial) score++;

    return (score / 4).clamp(0, 1).toDouble();
  }

  Color _strengthColor(double v, BuildContext context) {
    if (v < 0.25) return Colors.red;
    if (v < 0.5) return Colors.orange;
    if (v < 0.75) return Colors.amber[700]!;
    return Colors.green;
    }

  String _strengthLabel(double v) {
    if (v == 0) return '';
    if (v < 0.25) return 'Very weak';
    if (v < 0.5) return 'Weak';
    if (v < 0.75) return 'Good';
    return 'Strong';
  }

  String? _validateCurrent(String? v) {
    if (v == null || v.trim().isEmpty) return 'Enter your current password';
    if (v.trim().length < 6) return 'Current password looks too short';
    return null;
  }

  String? _validateNew(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Enter a new password';
    if (value.length < 8) return 'Use at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Add at least one uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Add at least one lowercase letter';
    if (!RegExp(r'\d').hasMatch(value)) return 'Add at least one number';
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-\[\]\\;/+=~`]').hasMatch(value)) {
      return 'Add at least one special character';
    }
    if (value == _currentCtrl.text) return 'New password must be different';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Re-enter the new password';
    if (v != _newCtrl.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) {
      HapticFeedback.lightImpact();
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);
    try {
      final handler = widget.onSubmit ?? _DemoChangePasswordService.updatePassword;
      await handler(_currentCtrl.text.trim(), _newCtrl.text.trim());
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
      Navigator.of(context).maybePop();
    } catch (e) {
      if (!mounted) return;
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canSubmit = !_isSubmitting &&
        (_formKey.currentState?.validate() ?? false) &&
        _passwordStrength >= 0.5;

    return WillPopScope(
      onWillPop: () async => !_isSubmitting,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Secure your account by choosing a strong, unique password.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _currentCtrl,
                  focusNode: _currentNode,
                  textInputAction: TextInputAction.next,
                  obscureText: _obscureCurrent,
                  decoration: InputDecoration(
                    labelText: 'Current password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                      icon: Icon(_obscureCurrent ? Icons.visibility : Icons.visibility_off),
                      tooltip: _obscureCurrent ? 'Show password' : 'Hide password',
                    ),
                  ),
                  validator: _validateCurrent,
                  onFieldSubmitted: (_) => _newNode.requestFocus(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _newCtrl,
                  focusNode: _newNode,
                  textInputAction: TextInputAction.next,
                  obscureText: _obscureNew,
                  decoration: InputDecoration(
                    labelText: 'New password',
                    prefixIcon: const Icon(Icons.lock_reset),
                    helperText: 'Use at least 8 chars with upper, lower, number and symbol.',
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscureNew = !_obscureNew),
                      icon: Icon(_obscureNew ? Icons.visibility : Icons.visibility_off),
                      tooltip: _obscureNew ? 'Show password' : 'Hide password',
                    ),
                  ),
                  validator: _validateNew,
                  onFieldSubmitted: (_) => _confirmNode.requestFocus(),
                ),
                const SizedBox(height: 8),
                _PasswordStrengthMeter(
                  strength: _passwordStrength,
                  label: _strengthLabel(_passwordStrength),
                  color: _strengthColor(_passwordStrength, context),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmCtrl,
                  focusNode: _confirmNode,
                  textInputAction: TextInputAction.done,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'Confirm new password',
                    prefixIcon: const Icon(Icons.verified_user_outlined),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                      tooltip: _obscureConfirm ? 'Show password' : 'Hide password',
                    ),
                  ),
                  validator: _validateConfirm,
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 24),
                _RequirementsList(newPassword: _newCtrl.text),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check),
                    label: Text(_isSubmitting ? 'Updating...' : 'Update Password'),
                    onPressed: canSubmit ? _submit : null,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Use account recovery if you forgot your current password.'),
                            ),
                          );
                        },
                  icon: const Icon(Icons.help_outline),
                  label: const Text('Forgot current password?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordStrengthMeter extends StatelessWidget {
  const _PasswordStrengthMeter({
    Key? key,
    required this.strength,
    required this.label,
    required this.color,
  }) : super(key: key);

  final double strength;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (strength == 0) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: strength,
            color: color,
            backgroundColor: color.withOpacity(0.2),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Strength: $label',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _RequirementsList extends StatelessWidget {
  const _RequirementsList({Key? key, required this.newPassword}) : super(key: key);

  final String newPassword;

  bool get _len => newPassword.length >= 8;
  bool get _upper => RegExp(r'[A-Z]').hasMatch(newPassword);
  bool get _lower => RegExp(r'[a-z]').hasMatch(newPassword);
  bool get _digit => RegExp(r'\d').hasMatch(newPassword);
  bool get _special => RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-\[\]\\;/+=~`]').hasMatch(newPassword);

  @override
  Widget build(BuildContext context) {
    final items = <_ReqItem>[
      _ReqItem('At least 8 characters', _len),
      _ReqItem('Uppercase letter (A-Z)', _upper),
      _ReqItem('Lowercase letter (a-z)', _lower),
      _ReqItem('Number (0-9)', _digit),
      _ReqItem('Special character (!@#…)', _special),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Password requirements', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        ...items.map(
          (e) => Row(
            children: [
              Icon(
                e.ok ? Icons.check_circle : Icons.radio_button_unchecked,
                color: e.ok ? Colors.green : Theme.of(context).disabledColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(e.text)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReqItem {
  final String text;
  final bool ok;
  _ReqItem(this.text, this.ok);
}

/// Demo service used when no onSubmit is provided to the page.
/// Replace this logic with your auth provider (e.g., FirebaseAuth reauth + updatePassword).
class _DemoChangePasswordService {
  static Future<void> updatePassword(String currentPassword, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 900));
    // Simulate a very simple "current password" check for demo purposes only.
    // In production, you must reauthenticate the user securely on the server/auth provider.
    if (currentPassword.trim().isEmpty) {
      throw Exception('Current password is required');
    }
    if (currentPassword == newPassword) {
      throw Exception('New password must be different from current password');
    }
    // Success (no-op).
  }
}