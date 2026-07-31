import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const Map<String, Map<String, String>> _localizedValues = {
    'hi': {
      'welcome_title': 'हाईवे सेतू 2.0',
      'welcome_subtitle': 'भारतीय ट्रक चालकों, ढाबा मालिकों एवं मैकेनिक भाइयों का अपना साथी',
      'select_language': 'अपनी भाषा चुनें / Select Language',
      'role_driver': 'वाहन चालक (Truck Driver)',
      'role_dhaba': 'ढाबा मालिक (Dhaba Owner)',
      'role_mechanic': 'मैकेनिक (Breakdown Unit)',
      'home': 'मुख्य पृष्ठ',
      'trip': 'सफर / यात्रा',
      'no_active_trip': 'कोई सक्रिय यात्रा नहीं',
      'start_trip_now': 'यात्रा शुरू करें',
      'end_trip_now': 'यात्रा समाप्त करें',
      'nearby_dhabas': 'आस-पास के ढाबे',
      'nearby_mechanics': 'आस-पास के मैकेनिक',
      'recent_trips': 'हाल की यात्राएं',
      'order': 'ऑर्डर करें',
      'call_mechanic': 'मैकेनिक बुलाएं',
      'driver_arriving': 'चालक 25 मिनट में पहुँच रहे हैं',
      'food_ready': 'भोजन तैयार है',
      'parking_available': 'ट्रक पार्किंग उपलब्ध',
      'fatigue_alert': 'चालक थकान चेतावनी: 4 घंटे से लगातार ड्राइविंग। 9 किमी आगे विश्राम स्थल।',
    },
    'en': {
      'welcome_title': 'Highways24 2.0',
      'welcome_subtitle': 'India’s Dedicated Highway Companion for Drivers, Dhabas & Mechanics',
      'select_language': 'Select Language',
      'role_driver': 'Truck Driver',
      'role_dhaba': 'Dhaba Owner',
      'role_mechanic': 'Roadside Mechanic',
      'home': 'Home',
      'trip': 'Trip Journey',
      'no_active_trip': 'No Active Trip',
      'start_trip_now': 'START TRIP NOW',
      'end_trip_now': 'END TRIP NOW',
      'nearby_dhabas': 'Nearby Verified Dhabas',
      'nearby_mechanics': 'Nearby Mechanics',
      'recent_trips': 'Recent Trip Logs',
      'order': 'Order Food',
      'call_mechanic': 'Call Mechanic',
      'driver_arriving': 'Driver arriving in 25 mins',
      'food_ready': 'Food Ready for Pickup',
      'parking_available': 'Truck Parking Available',
      'fatigue_alert': 'Fatigue Alert: 4 hours continuous driving. Rest stop 9 km ahead.',
    },
    'pa': {
      'welcome_title': 'ਹਾਏਵੇ ਸੇਤੂ 2.0',
      'welcome_subtitle': 'ਭਾਰਤੀ ਟਰੱਕ ਡਰਾਈਵਰਾਂ, ਢਾਬਾ ਮਾਲਕਾਂ ਅਤੇ ਮਕੈਨਿਕ ਵੀਰਾਂ ਦਾ ਆਪਣਾ ਸਾਥੀ',
      'select_language': 'ਆਪਣੀ ਭਾਸ਼ਾ ਚੁਣੋ / Select Language',
      'role_driver': 'ਗੱਡੀ ਡਰਾਈਵਰ (Driver)',
      'role_dhaba': 'ਢਾਬਾ ਮਾਲਕ (Dhaba Partner)',
      'role_mechanic': 'ਮਕੈਨਿਕ (Breakdown Unit)',
      'home': 'ਹੋਮ',
      'trip': 'ਸਫ਼ਰ / ਯਾਤਰਾ',
      'no_active_trip': 'ਕੋਈ ਚਾਲੂ ਯਾਤਰਾ ਨਹੀਂ',
      'start_trip_now': 'ਯਾਤਰਾ ਸ਼ੁਰੂ ਕਰੋ',
      'end_trip_now': 'ਯਾਤਰਾ ਸਮਾਪਤ ਕਰੋ',
      'nearby_dhabas': 'ਨੇੜਲੇ ਢਾਬੇ',
      'nearby_mechanics': 'ਨੇੜਲੇ ਮਕੈਨਿਕ',
      'recent_trips': 'ਪਿਛਲੀਆਂ ਯਾਤਰਾਵਾਂ',
      'order': 'ਆਰਡਰ ਕਰੋ',
      'call_mechanic': 'ਮਕੈਨਿਕ ਬੁਲਾਓ',
      'driver_arriving': 'ਡਰਾਈਵਰ 25 ਮਿੰਟ ਵਿੱਚ ਪਹੁੰਚ ਰਿਹਾ ਹੈ',
      'food_ready': 'ਖਾਣਾ ਤਿਆਰ ਹੈ',
      'parking_available': 'ਟਰੱਕ ਪਾਰਕਿੰਗ ਉਪਲਬਧ',
      'fatigue_alert': 'ਥਕਾਵਟ ਚੇਤਾਵਨੀ: 4 ਘੰਟੇ ਤੋਂ ਲਗਾਤਾਰ ਡਰਾਈਵਿੰਗ। 9 ਕਿਲੋਮੀਟਰ ਅੱਗੇ ਆਰਾਮ ਘਰ।',
    },
  };

  String tr(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? _localizedValues['hi']?[key] ?? key;
  }
}

class IndianFormatter {
  // Indian currency formatting: ₹1,25,000
  static String formatCurrency(double amount) {
    int whole = amount.round();
    String str = whole.toString();
    if (str.length <= 3) return '₹$str';

    String lastThree = str.substring(str.length - 3);
    String remaining = str.substring(0, str.length - 3);

    String formattedRemaining = '';
    while (remaining.length > 2) {
      formattedRemaining = ',${remaining.substring(remaining.length - 2)}$formattedRemaining';
      remaining = remaining.substring(0, remaining.length - 2);
    }
    formattedRemaining = '$remaining$formattedRemaining';

    return '₹$formattedRemaining,$lastThree';
  }

  // Indian phone number formatting: +91 98765 43210
  static String formatPhone(String rawPhone) {
    String digits = rawPhone.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) {
      return '+91 ${digits.substring(0, 5)} ${digits.substring(5)}';
    } else if (digits.length == 12 && digits.startsWith('91')) {
      return '+91 ${digits.substring(2, 7)} ${digits.substring(7)}';
    }
    return rawPhone;
  }
}
