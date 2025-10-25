class OAuthConfig {
  static const String webClientId = String.fromEnvironment(
      'GOOGLE_WEB_CLIENT_ID',
      defaultValue:
          '288102825173-3rlab04bf07a1g9pkb24gkt1gk0sgs5o.apps.googleusercontent.com');

  static const String iosClientId = String.fromEnvironment(
      'GOOGLE_IOS_CLIENT_ID',
      defaultValue:
          '288102825173-3rlab04bf07a1g9pkb24gkt1gk0sgs5o.apps.googleusercontent.com');

  static const String androidClientId = String.fromEnvironment(
      'GOOGLE_ANDROID_CLIENT_ID',
      defaultValue:
          '288102825173-ahcu3mt6a78tq2qcon0fq4vioc464uh5.apps.googleusercontent.com');
}
