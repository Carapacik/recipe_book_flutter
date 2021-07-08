import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/src/app/app.dart';
import 'package:recipe_book_flutter/src/core/localization/localization.dart';
import 'package:recipe_book_flutter/src/core/widgets/glass_panel.dart';
import 'package:recipe_book_flutter/src/features/auth/presentation/auth_controller.dart';

Future<bool> showAuthDialog(BuildContext context) async {
  try {
    return await showDialog<bool>(
          context: context,
          builder: (_) => const AuthDialog(),
        ) ??
        false;
  } on Object catch (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(exception: error, stack: stackTrace),
    );
    return false;
  }
}

class const AuthDialog({super.key}) extends StatefulWidget {
  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState() extends State<AuthDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _register = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthController auth = AuthScope.of(context);
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      backgroundColor: Colors.transparent,
      child: GlassPanel(
        blur: 32,
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DecoratedBox(
                        decoration: ShapeDecoration(
                          color: Theme.of(context).colorScheme.primary
                              .withAlpha(55),
                          shape: RoundedSuperellipseBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Icon(Icons.restaurant_menu, size: 30),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _register
                                  ? context.l10n.createAccount
                                  : context.l10n.welcomeBack,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _register
                                  ? context.l10n.registerDescription
                                  : context.l10n.loginDescription,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: context.l10n.close,
                        onPressed: () => Navigator.pop(context, false),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  if (_register) ...[
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: context.l10n.name,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      validator: (value) => (value?.trim().length ?? 0) < 2
                          ? context.l10n.minimumTwoCharacters
                          : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: context.l10n.email,
                      prefixIcon: const Icon(Icons.alternate_email),
                    ),
                    validator: (value) => (value?.contains('@') ?? false)
                        ? null
                        : context.l10n.invalidEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    onFieldSubmitted: (_) => _submit(auth),
                    decoration: InputDecoration(
                      labelText: context.l10n.password,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (value) => (value?.length ?? 0) < 8
                        ? context.l10n.minimumEightCharacters
                        : null,
                  ),
                  if (auth.error case final String error?) ...[
                    const SizedBox(height: 16),
                    DecoratedBox(
                      decoration: ShapeDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        shape: RoundedSuperellipseBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Text(
                          error,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onErrorContainer,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  Wrap(
                    alignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      TextButton(
                        onPressed: auth.isSubmitting
                            ? null
                            : () => setState(() => _register = !_register),
                        child: Text(
                          _register
                              ? context.l10n.alreadyHaveAccount
                              : context.l10n.createAccount,
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: auth.isSubmitting
                            ? null
                            : () => _submit(auth),
                        icon: auth.isSubmitting
                            ? const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(_register ? Icons.person_add : Icons.login),
                        label: Text(
                          _register ? context.l10n.create : context.l10n.signIn,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(AuthController auth) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    try {
      final bool success = _register
          ? await auth.register(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
            )
          : await auth.login(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            );
      if (success && mounted) {
        Navigator.pop(context, true);
      }
    } on Object catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }
}
