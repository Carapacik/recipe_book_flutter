class const Ingredient({
  required final String title,
  required final List<String> names,
}) {
  factory fromJson(Map<String, Object?> json) => Ingredient(
    title: json['title'] as String? ?? '',
    names: (json['ingredientNames'] as List<Object?>? ?? const [])
        .whereType<String>()
        .toList(growable: false),
  );
}
