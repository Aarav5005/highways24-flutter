class LoyaltyRewardModel {
  final String id;
  final String title;
  final String description;
  final int pointsCost;
  final double discountValue;
  final String promoCode;
  final bool isRedeemed;

  LoyaltyRewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsCost,
    required this.discountValue,
    required this.promoCode,
    this.isRedeemed = false,
  });

  LoyaltyRewardModel copyWith({
    String? id,
    String? title,
    String? description,
    int? pointsCost,
    double? discountValue,
    String? promoCode,
    bool? isRedeemed,
  }) {
    return LoyaltyRewardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      pointsCost: pointsCost ?? this.pointsCost,
      discountValue: discountValue ?? this.discountValue,
      promoCode: promoCode ?? this.promoCode,
      isRedeemed: isRedeemed ?? this.isRedeemed,
    );
  }
}
