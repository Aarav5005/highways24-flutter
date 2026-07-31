class AppConfig {
  static const String baseUrl = 'https://highway-setu-backend.onrender.com/api/v1';
  static const String localBaseUrl = 'http://10.0.2.2:3000/api/v1';
  
  // Google Maps API Key
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: 'AIzaSyHighwaySetuGoogleMapsApiKeySample',
  );

  // Endpoints
  static const String authSendOtp = '$baseUrl/auth/send-otp';
  static const String authVerifyOtp = '$baseUrl/auth/verify-otp';
  static const String authRefresh = '$baseUrl/auth/refresh';
  static const String dhabas = '$baseUrl/dhabas';
  static const String menu = '$baseUrl/menu';
  static const String mechanics = '$baseUrl/mechanics';
  static const String trips = '$baseUrl/trips';
  static const String orders = '$baseUrl/orders';
  static const String mechanicRequests = '$baseUrl/mechanic-requests';
  static const String sos = '$baseUrl/sos';
  static const String loyalty = '$baseUrl/loyalty';
  static const String referrals = '$baseUrl/referrals';
}
