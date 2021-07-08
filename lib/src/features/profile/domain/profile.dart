class const Profile({
  required final String name,
  required final String email,
  required final String description,
  required final int recipesCount,
  required final int likesCount,
  required final int favoritesCount,
}) {
  factory fromJson(Map<String, Object?> json) => Profile(
    name: json['name'] as String? ?? '',
    email: json['login'] as String? ?? '',
    description: json['description'] as String? ?? '',
    recipesCount: (json['recipesCount'] as num?)?.toInt() ?? 0,
    likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
    favoritesCount: (json['favoritesCount'] as num?)?.toInt() ?? 0,
  );
}
