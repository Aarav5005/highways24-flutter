class DhabaSearchQuery {
  final String keyword;
  final bool requiresTruckParking;
  final bool requires24Hours;
  final bool requiresPureVeg;
  final double maxDistanceKm;

  const DhabaSearchQuery({
    this.keyword = '',
    this.requiresTruckParking = false,
    this.requires24Hours = false,
    this.requiresPureVeg = false,
    this.maxDistanceKm = 100.0,
  });

  DhabaSearchQuery copyWith({
    String? keyword,
    bool? requiresTruckParking,
    bool? requires24Hours,
    bool? requiresPureVeg,
    double? maxDistanceKm,
  }) {
    return DhabaSearchQuery(
      keyword: keyword ?? this.keyword,
      requiresTruckParking: requiresTruckParking ?? this.requiresTruckParking,
      requires24Hours: requires24Hours ?? this.requires24Hours,
      requiresPureVeg: requiresPureVeg ?? this.requiresPureVeg,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
    );
  }
}
