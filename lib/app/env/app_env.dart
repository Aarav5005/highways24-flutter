enum Environment {
  local,
  dev,
  qa,
  uat,
  staging,
  prod,
}

class AppEnv {
  static Environment current = Environment.dev;

  static String get name => current.name;

  static String get baseUrl {
    switch (current) {
      case Environment.local:
        return 'http://10.0.2.2:3000/api/v1';
      case Environment.dev:
      case Environment.qa:
      case Environment.uat:
      case Environment.staging:
      case Environment.prod:
        return 'https://highway-setu-backend.onrender.com/api/v1';
    }
  }
}
