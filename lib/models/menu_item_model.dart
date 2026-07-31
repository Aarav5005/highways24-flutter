enum FoodCategory {
  starters,
  mainCourse,
  breads,
  beverages,
  desserts,
}

extension FoodCategoryExtension on FoodCategory {
  String get label {
    switch (this) {
      case FoodCategory.starters:
        return 'Starters & Snacks';
      case FoodCategory.mainCourse:
        return 'Main Course';
      case FoodCategory.breads:
        return 'Roti & Paratha';
      case FoodCategory.beverages:
        return 'Chai & Drinks';
      case FoodCategory.desserts:
        return 'Sweets / Desserts';
    }
  }
}

class MenuItemModel {
  final String id;
  final String dhabaId;
  final String name;
  final String description;
  final double price;
  final FoodCategory category;
  final bool isVeg;
  final bool isAvailable;
  final String imageUrl;
  final int prepTimeMins;

  MenuItemModel({
    required this.id,
    required this.dhabaId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.isVeg,
    this.isAvailable = true,
    required this.imageUrl,
    this.prepTimeMins = 15,
  });

  MenuItemModel copyWith({
    String? id,
    String? dhabaId,
    String? name,
    String? description,
    double? price,
    FoodCategory? category,
    bool? isVeg,
    bool? isAvailable,
    String? imageUrl,
    int? prepTimeMins,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      dhabaId: dhabaId ?? this.dhabaId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      isVeg: isVeg ?? this.isVeg,
      isAvailable: isAvailable ?? this.isAvailable,
      imageUrl: imageUrl ?? this.imageUrl,
      prepTimeMins: prepTimeMins ?? this.prepTimeMins,
    );
  }
}
