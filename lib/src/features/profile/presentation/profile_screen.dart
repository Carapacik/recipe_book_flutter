import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/src/app/app.dart';
import 'package:recipe_book_flutter/src/app/app_dependencies.dart';
import 'package:recipe_book_flutter/src/core/layout/window_size_class.dart';
import 'package:recipe_book_flutter/src/core/localization/localization.dart';
import 'package:recipe_book_flutter/src/core/widgets/content_width.dart';
import 'package:recipe_book_flutter/src/core/widgets/glass_panel.dart';
import 'package:recipe_book_flutter/src/features/profile/domain/profile.dart';
import 'package:recipe_book_flutter/src/features/profile/presentation/profile_controller.dart';
import 'package:recipe_book_flutter/src/features/recipes/presentation/controllers/recipe_feed_controller.dart';
import 'package:recipe_book_flutter/src/features/recipes/presentation/widgets/recipe_grid.dart';

class const ProfileScreen({super.key}) extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState() extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _description = TextEditingController();
  final _password = TextEditingController();
  ProfileController? _profileController;
  RecipeFeedController? _recipeController;
  bool _editing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_profileController != null) {
      return;
    }
    final AppDependencies dependencies = AppScope.of(context);
    _profileController = ProfileController(dependencies.profileRepository);
    final recipeController = RecipeFeedController(
      dependencies.recipeRepository,
      type: RecipeFeedType.mine,
    );
    _recipeController = recipeController;
    unawaited(recipeController.loadInitial());
    unawaited(_loadProfile());
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _description.dispose();
    _password.dispose();
    _profileController?.dispose();
    _recipeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_profileController, _recipeController]),
      builder: (context, _) {
        final Profile? profile = _profileController!.profile;
        if (_profileController!.isLoading && profile == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (profile == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _profileController!.error ?? context.l10n.profileNotFound,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _loadProfile,
                    child: Text(context.l10n.retry),
                  ),
                ],
              ),
            ),
          );
        }
        return ListView(
          children: [
            ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ProfileHeader(
                    profile: profile,
                    editing: _editing,
                    isSaving: _profileController!.isSaving,
                    onEdit: () => setState(() => _editing = true),
                    onCancel: _cancelEditing,
                    onSave: _save,
                  ),
                  const SizedBox(height: 20),
                  _ProfileForm(
                    formKey: _formKey,
                    editing: _editing,
                    name: _name,
                    email: _email,
                    description: _description,
                    password: _password,
                  ),
                  if (_profileController!.error case final error?) ...[
                    const SizedBox(height: 12),
                    Text(
                      error,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  _Stats(profile: profile),
                  const SizedBox(height: 40),
                  Text(
                    context.l10n.myRecipes,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 20),
                  if (_recipeController!.items.isEmpty)
                    SizedBox(
                      height: 220,
                      child: Center(
                        child: _recipeController!.isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                _recipeController!.error ??
                                    context.l10n.noPublishedRecipes,
                              ),
                      ),
                    )
                  else
                    RecipeGrid(
                      recipes: _recipeController!.items,
                      onFavorite: _recipeController!.toggleFavorite,
                      onLike: _recipeController!.toggleLike,
                      onChanged: () => unawaited(_recipeController!.refresh()),
                    ),
                  if (_recipeController!.hasMore) ...[
                    const SizedBox(height: 20),
                    Center(
                      child: OutlinedButton(
                        onPressed: _recipeController!.isLoading
                            ? null
                            : _recipeController!.loadMore,
                        child: Text(context.l10n.showMore),
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadProfile() async {
    try {
      await _profileController!.load();
      final Profile? profile = _profileController!.profile;
      if (profile != null) {
        _fill(profile);
      }
    } on Object catch (error) {
      _showError(error);
    }
  }

  void _fill(Profile profile) {
    _name.text = profile.name;
    _email.text = profile.email;
    _description.text = profile.description;
    _password.clear();
  }

  void _cancelEditing() {
    final Profile? profile = _profileController!.profile;
    if (profile != null) {
      _fill(profile);
    }
    setState(() => _editing = false);
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    try {
      final bool success = await _profileController!.update(
        name: _name.text.trim(),
        email: _email.text.trim(),
        description: _description.text.trim(),
        password: _password.text,
      );
      if (success && mounted) {
        setState(() => _editing = false);
      }
    } on Object catch (error) {
      _showError(error);
    }
  }

  void _showError(Object error) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}

class const _ProfileHeader({
  required final Profile profile,
  required final bool editing,
  required final bool isSaving,
  required final VoidCallback onEdit,
  required final VoidCallback onCancel,
  required final VoidCallback onSave,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 12,
      children: [
        CircleAvatar(
          radius: 36,
          child: Text(
            profile.name.isEmpty
                ? '?'
                : profile.name.characters.first.toUpperCase(),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Text(
          profile.name,
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        if (!editing)
          OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            label: Text(context.l10n.edit),
          )
        else ...[
          TextButton(
            onPressed: isSaving ? null : onCancel,
            child: Text(context.l10n.cancel),
          ),
          FilledButton.icon(
            onPressed: isSaving ? null : onSave,
            icon: isSaving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_outlined),
            label: Text(context.l10n.save),
          ),
        ],
      ],
    );
  }
}

class const _ProfileForm({
  required final GlobalKey<FormState> formKey,
  required final bool editing,
  required final TextEditingController name,
  required final TextEditingController email,
  required final TextEditingController description,
  required final TextEditingController password,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fields = [
      TextFormField(
        controller: name,
        readOnly: !editing,
        decoration: InputDecoration(labelText: context.l10n.name),
        validator: (value) => (value?.trim().length ?? 0) < 2
            ? context.l10n.minimumTwoCharacters
            : null,
      ),
      TextFormField(
        controller: email,
        readOnly: !editing,
        decoration: InputDecoration(labelText: context.l10n.email),
        validator: (value) =>
            (value?.contains('@') ?? false) ? null : context.l10n.invalidEmail,
      ),
      TextFormField(
        controller: description,
        readOnly: !editing,
        minLines: 3,
        maxLines: 5,
        maxLength: 150,
        decoration: InputDecoration(labelText: context.l10n.about),
      ),
      if (editing)
        TextFormField(
          controller: password,
          obscureText: true,
          decoration: InputDecoration(
            labelText: context.l10n.newPasswordOptional,
          ),
          validator: (value) =>
              value != null && value.isNotEmpty && value.length < 8
              ? context.l10n.minimumEightCharacters
              : null,
        ),
    ];
    return Form(
      key: formKey,
      child: GlassPanel(
        blur: 28,
        color: Colors.white.withAlpha(195),
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool horizontal =
                constraints.maxWidth >= AppBreakpoints.medium;
            if (!horizontal) {
              return Column(
                children: fields
                    .expand((field) => [field, const SizedBox(height: 16)])
                    .toList(growable: false),
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      fields[0],
                      const SizedBox(height: 16),
                      fields[1],
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      fields[2],
                      if (fields.length > 3) ...[
                        const SizedBox(height: 16),
                        fields[3],
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class const _Stats({required final Profile profile}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = (constraints.maxWidth - 24) / 3;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _StatCard(
              width: width,
              value: profile.recipesCount,
              label: context.l10n.recipesCountLabel,
            ),
            _StatCard(
              width: width,
              value: profile.likesCount,
              label: context.l10n.likesCountLabel,
            ),
            _StatCard(
              width: width,
              value: profile.favoritesCount,
              label: context.l10n.favoritesCountLabel,
            ),
          ],
        );
      },
    );
  }
}

class const _StatCard({
  required final double width,
  required final int value,
  required final String label,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width < 180 ? double.infinity : width,
      child: GlassPanel(
        blur: 28,
        color: Colors.white.withAlpha(195),
        borderRadius: BorderRadius.circular(24),
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Text('$value', style: Theme.of(context).textTheme.headlineMedium),
            Text(label),
          ],
        ),
      ),
    );
  }
}
