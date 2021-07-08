import 'dart:async';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/src/app/app.dart';
import 'package:recipe_book_flutter/src/core/layout/window_size_class.dart';
import 'package:recipe_book_flutter/src/core/localization/localization.dart';
import 'package:recipe_book_flutter/src/core/navigation/app_routes.dart';
import 'package:recipe_book_flutter/src/core/widgets/app_network_image.dart';
import 'package:recipe_book_flutter/src/core/widgets/content_width.dart';
import 'package:recipe_book_flutter/src/core/widgets/glass_page_app_bar.dart';
import 'package:recipe_book_flutter/src/core/widgets/glass_panel.dart';
import 'package:recipe_book_flutter/src/features/auth/presentation/auth_controller.dart';
import 'package:recipe_book_flutter/src/features/auth/presentation/auth_dialog.dart';
import 'package:recipe_book_flutter/src/features/recipes/data/recipe_repository.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/ingredient.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe_draft.dart';

class const RecipeFormScreen({final int? recipeId, super.key})
    extends StatefulWidget {
  @override
  State<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState() extends State<RecipeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _cookingTime = TextEditingController();
  final _portions = TextEditingController();
  final _tags = <TextEditingController>[TextEditingController()];
  final _steps = <TextEditingController>[TextEditingController()];
  final _ingredients = <_IngredientControllers>[_IngredientControllers.empty()];

  RecipeRepository? _repository;
  bool _isLoading = false;
  bool _isSaving = false;
  final List<RecipeImageDraft> _images = [];
  List<String> _existingImages = const [];
  bool _authGuardScheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final AuthController auth = AuthScope.of(context);
    if (auth.status == AuthStatus.checking) {
      return;
    }
    if (!auth.isAuthenticated) {
      if (!_authGuardScheduled) {
        _authGuardScheduled = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          unawaited(_guardAuthentication());
        });
      }
      return;
    }
    if (_repository != null) {
      return;
    }
    _repository = AppScope.of(context).recipeRepository;
    if (widget.recipeId != null) {
      unawaited(_loadRecipe());
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _cookingTime.dispose();
    _portions.dispose();
    for (final TextEditingController controller in [..._tags, ..._steps]) {
      controller.dispose();
    }
    for (final _IngredientControllers group in _ingredients) {
      group.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthController auth = AuthScope.of(context);
    return Scaffold(
      appBar: GlassPageAppBar(
        title: widget.recipeId == null
            ? context.l10n.newRecipe
            : context.l10n.editing,
      ),
      body: GlassBackground(
        child: !auth.isAuthenticated || _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: ContentWidth(
                  maxWidth: 1000,
                  child: GlassPanel(
                    blur: 28,
                    color: Colors.white.withAlpha(195),
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _ImagePicker(
                            images: _images,
                            existingImages: _existingImages,
                            onPick: _pickImages,
                            onRemove: (index) =>
                                setState(() => _images.removeAt(index)),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _title,
                            maxLength: 200,
                            decoration: InputDecoration(
                              labelText: context.l10n.title,
                            ),
                            validator: _required,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _description,
                            minLines: 3,
                            maxLines: 6,
                            maxLength: 150,
                            decoration: InputDecoration(
                              labelText: context.l10n.shortDescription,
                            ),
                            validator: _required,
                          ),
                          const SizedBox(height: 16),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final bool horizontal =
                                  constraints.maxWidth >=
                                  AppBreakpoints.compact;
                              final fields = [
                                TextFormField(
                                  controller: _cookingTime,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: context.l10n.cookingTimeLabel,
                                  ),
                                  validator: (value) =>
                                      _numberInRange(value, 1, 1440),
                                ),
                                TextFormField(
                                  controller: _portions,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: context.l10n.portions,
                                  ),
                                  validator: (value) =>
                                      _numberInRange(value, 1, 1000),
                                ),
                              ];
                              if (!horizontal) {
                                return Column(
                                  children: [
                                    fields[0],
                                    const SizedBox(height: 16),
                                    fields[1],
                                  ],
                                );
                              }
                              return Row(
                                children: [
                                  Expanded(child: fields[0]),
                                  const SizedBox(width: 16),
                                  Expanded(child: fields[1]),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                          _DynamicFields(
                            title: context.l10n.tags,
                            hint: context.l10n.tagHint,
                            controllers: _tags,
                            onAdd: () => setState(
                              () => _tags.add(TextEditingController()),
                            ),
                            onRemove: (index) =>
                                _removeController(_tags, index),
                          ),
                          const SizedBox(height: 32),
                          _DynamicFields(
                            title: context.l10n.cookingSteps,
                            hint: context.l10n.stepActionHint,
                            controllers: _steps,
                            multiline: true,
                            onAdd: () => setState(
                              () => _steps.add(TextEditingController()),
                            ),
                            onRemove: (index) =>
                                _removeController(_steps, index),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  context.l10n.ingredients,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall,
                                ),
                              ),
                              FilledButton.tonalIcon(
                                onPressed: () => setState(
                                  () => _ingredients.add(
                                    _IngredientControllers.empty(),
                                  ),
                                ),
                                icon: const Icon(Icons.add),
                                label: Text(context.l10n.group),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ..._ingredients.indexed.map(
                            (entry) => _IngredientGroup(
                              index: entry.$1,
                              controllers: entry.$2,
                              canRemove: _ingredients.length > 1,
                              onChanged: () => setState(() {}),
                              onRemove: () => _removeIngredientGroup(entry.$1),
                            ),
                          ),
                          const SizedBox(height: 32),
                          FilledButton.icon(
                            onPressed: _isSaving ? null : _save,
                            icon: _isSaving
                                ? const SizedBox.square(
                                    dimension: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.save_outlined),
                            label: Text(
                              widget.recipeId == null
                                  ? context.l10n.createRecipe
                                  : context.l10n.save,
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _guardAuthentication() async {
    try {
      final bool signedIn = await showAuthDialog(context);
      if (!signedIn && mounted) {
        await Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (_) => false,
        );
      }
    } on Object catch (error) {
      _showError(error);
    }
  }

  Future<void> _loadRecipe() async {
    setState(() => _isLoading = true);
    try {
      final Recipe recipe = await _repository!.getById(widget.recipeId!);
      _fill(recipe);
    } on Object catch (error) {
      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _fill(Recipe recipe) {
    _title.text = recipe.title;
    _description.text = recipe.description;
    _cookingTime.text = '${recipe.cookingTime}';
    _portions.text = '${recipe.portions}';
    _existingImages = recipe.imageUrls;
    _replaceControllers(_tags, recipe.tags);
    _replaceControllers(_steps, recipe.steps);
    for (final _IngredientControllers ingredient in _ingredients) {
      ingredient.dispose();
    }
    _ingredients
      ..clear()
      ..addAll(recipe.ingredients.map(_IngredientControllers.fromIngredient));
    if (_ingredients.isEmpty) {
      _ingredients.add(_IngredientControllers.empty());
    }
  }

  Future<void> _pickImages() async {
    try {
      final typeGroup = XTypeGroup(
        label: context.l10n.images,
        extensions: const ['jpg', 'jpeg', 'png', 'webp'],
        mimeTypes: const ['image/jpeg', 'image/png', 'image/webp'],
      );
      final List<XFile> files = await openFiles(
        acceptedTypeGroups: [typeGroup],
      );
      if (files.isEmpty) {
        return;
      }
      final List<RecipeImageDraft> images = [];
      for (final file in files) {
        images.add(
          RecipeImageDraft(bytes: await file.readAsBytes(), name: file.name),
        );
      }
      if (!mounted) {
        return;
      }
      setState(() {
        _images
          ..clear()
          ..addAll(images);
      });
    } on Object catch (error) {
      _showError(error);
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final bool replacingImages = _images.isNotEmpty;
    if ((widget.recipeId == null || replacingImages) && _images.length < 2) {
      _showError(context.l10n.selectAtLeastTwoImages);
      return;
    }
    setState(() => _isSaving = true);
    final draft = RecipeDraft(
      title: _title.text.trim(),
      description: _description.text.trim(),
      cookingTime: int.parse(_cookingTime.text),
      portions: int.parse(_portions.text),
      tags: _nonEmpty(_tags),
      steps: _nonEmpty(_steps),
      ingredients: _ingredients
          .map(
            (group) => Ingredient(
              title: group.title.text.trim(),
              names: _nonEmpty(group.items),
            ),
          )
          .toList(growable: false),
      images: List.unmodifiable(_images),
    );
    try {
      if (widget.recipeId case final id?) {
        await _repository!.update(id, draft);
      } else {
        await _repository!.create(draft);
      }
      if (mounted) {
        Navigator.pop(context, true);
      }
    } on Object catch (error) {
      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  List<String> _nonEmpty(List<TextEditingController> controllers) => controllers
      .map((controller) => controller.text.trim())
      .where((value) => value.isNotEmpty)
      .toList(growable: false);

  void _replaceControllers(
    List<TextEditingController> target,
    List<String> values,
  ) {
    for (final controller in target) {
      controller.dispose();
    }
    target
      ..clear()
      ..addAll(values.map((value) => TextEditingController(text: value)));
    if (target.isEmpty) {
      target.add(TextEditingController());
    }
  }

  void _removeController(List<TextEditingController> list, int index) {
    if (list.length == 1) {
      list.single.clear();
      return;
    }
    setState(() => list.removeAt(index).dispose());
  }

  void _removeIngredientGroup(int index) {
    if (_ingredients.length == 1) {
      return;
    }
    setState(() => _ingredients.removeAt(index).dispose());
  }

  String? _required(String? value) =>
      (value?.trim().isEmpty ?? true) ? context.l10n.requiredField : null;

  String? _numberInRange(String? value, int min, int max) {
    final int? number = int.tryParse(value ?? '');
    return number == null || number < min || number > max
        ? context.l10n.numberRange(min, max)
        : null;
  }

  void _showError(Object error) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(error.toString())));
  }
}

class const _ImagePicker({
  required final List<RecipeImageDraft> images,
  required final List<String> existingImages,
  required final VoidCallback onPick,
  required final ValueChanged<int> onRemove,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool hasSelectedImages = images.isNotEmpty;
    final int imageCount = hasSelectedImages
        ? images.length
        : existingImages.length;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(190),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: Colors.white.withAlpha(180)),
        ),
      ),
      child: SizedBox(
        height: 280,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.photo_library_outlined),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      imageCount == 0
                          ? context.l10n.chooseAtLeastTwoImages
                          : context.l10n.imageCount(imageCount),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: onPick,
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    label: Text(
                      imageCount == 0
                          ? context.l10n.choose
                          : context.l10n.replace,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: imageCount == 0
                    ? _EmptyImageSelection(onPick: onPick)
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageCount,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, index) => AspectRatio(
                          aspectRatio: 4 / 3,
                          child: ClipRSuperellipse(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (hasSelectedImages)
                                  Image.memory(
                                    images[index].bytes,
                                    fit: BoxFit.cover,
                                  )
                                else
                                  AppNetworkImage(
                                    imagePath: existingImages[index],
                                  ),
                                if (hasSelectedImages)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: IconButton.filled(
                                      tooltip: context.l10n.removeImage,
                                      onPressed: () => onRemove(index),
                                      icon: const Icon(Icons.close),
                                    ),
                                  ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: ColoredBox(
                                    color: Colors.black54,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        hasSelectedImages
                                            ? images[index].name
                                            : index == 0
                                            ? context.l10n.mainImage
                                            : context.l10n.imageNumber(
                                                index + 1,
                                              ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class const _EmptyImageSelection({required final VoidCallback onPick})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(20),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Colors.white.withAlpha(90),
          shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_photo_alternate_outlined, size: 44),
              const SizedBox(height: 8),
              Text(context.l10n.chooseImages),
            ],
          ),
        ),
      ),
    );
  }
}

class const _DynamicFields({
  required final String title,
  required final String hint,
  required final List<TextEditingController> controllers,
  required final VoidCallback onAdd,
  required final ValueChanged<int> onRemove,
  final bool multiline = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            IconButton.filledTonal(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...controllers.indexed.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: entry.$2,
                    minLines: multiline ? 2 : 1,
                    maxLines: multiline ? 4 : 1,
                    decoration: InputDecoration(
                      labelText: multiline
                          ? context.l10n.stepNumber(entry.$1 + 1)
                          : hint,
                    ),
                    validator: (value) => _validateNonEmpty(context, value),
                  ),
                ),
                IconButton(
                  onPressed: () => onRemove(entry.$1),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String? _validateNonEmpty(BuildContext context, String? value) =>
      (value?.trim().isEmpty ?? true) ? context.l10n.fillField : null;
}

class _IngredientControllers(
  final TextEditingController title,
  final List<TextEditingController> items,
) {
  factory empty() => _IngredientControllers(TextEditingController(), [
    TextEditingController(),
  ]);

  factory fromIngredient(Ingredient ingredient) => _IngredientControllers(
    TextEditingController(text: ingredient.title),
    ingredient.names
        .map((value) => TextEditingController(text: value))
        .toList(),
  );

  void dispose() {
    title.dispose();
    for (final TextEditingController controller in items) {
      controller.dispose();
    }
  }
}

class const _IngredientGroup({
  required final int index,
  required final _IngredientControllers controllers,
  required final bool canRemove,
  required final VoidCallback onChanged,
  required final VoidCallback onRemove,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controllers.title,
                    decoration: InputDecoration(
                      labelText: context.l10n.groupNumber(index + 1),
                    ),
                    validator: (value) =>
                        _DynamicFields._validateNonEmpty(context, value),
                  ),
                ),
                if (canRemove)
                  IconButton(
                    onPressed: onRemove,
                    icon: const Icon(Icons.delete_outline),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ...controllers.items.indexed.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: entry.$2,
                        decoration: InputDecoration(
                          labelText: context.l10n.ingredient,
                        ),
                        validator: (value) =>
                            _DynamicFields._validateNonEmpty(context, value),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (controllers.items.length == 1) {
                          controllers.items.single.clear();
                        } else {
                          controllers.items.removeAt(entry.$1).dispose();
                          onChanged();
                        }
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  controllers.items.add(TextEditingController());
                  onChanged();
                },
                icon: const Icon(Icons.add),
                label: Text(context.l10n.addIngredient),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
