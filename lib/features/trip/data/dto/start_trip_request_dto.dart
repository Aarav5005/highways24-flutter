class StartTripRequestDto {
  final String origin;
  final String destination;
  final double totalKm;

  const StartTripRequestDto({
    required this.origin,
    required this.destination,
    required this.totalKm,
  });

  Map<String, dynamic> toJson() {
    return {
      'origin': origin,
      'destination': destination,
      'total_km': totalKm,
    };
  }
}
