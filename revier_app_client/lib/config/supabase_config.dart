/// Configuration class for Supabase
class SupabaseConfig {
  /// The Supabase URL
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL',
      defaultValue: 'https://api.revierapp.de');

  /// The Supabase anonymous key
  static const String supabaseAnonKey = String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ewogICJyb2xlIjogImFub24iLAogICJpc3MiOiAic3VwYWJhc2UiLAogICJpYXQiOiAxNzQxMDQyODAwLAogICJleHAiOiAxODk4ODA5MjAwCn0.YhVf3oVheO54CO5pnpvmqwJhskt-TQXZmQTYKPUCEsc');

  /// OAuth redirect URL for mobile apps
  static const String redirectUrl = String.fromEnvironment(
      'SUPABASE_REDIRECT_URL',
      defaultValue: 'de.revierapp.client://login-callback/');

  // Endpoints classification
  static const List<String> systemEndpoints = [
    'auth',
    'system',
    // Add other system endpoints here
  ];

  // Check if an endpoint is a system endpoint (online-first)
  static bool isSystemEndpoint(String endpoint) {
    return systemEndpoints.any((e) => endpoint.contains(e));
  }
}
