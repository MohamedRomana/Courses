// NOTE: Stripe secret keys must NEVER be committed or shipped in a client app.
// The publishable key is public by design and is safe to keep here.
// Provide the secret key at runtime via --dart-define if you ever need server
// calls (payments currently run in offline/demo mode, so it can stay empty).
abstract class ApiKeys {
  static const String publishKey =
      "pk_test_51NnrcjFryzRUZDSnWOt9jtzTsVyCbi3BlL7FdfZPUPn0phQxBdJqDK2IHoxxxRPsO1Bpcl5bXjUaM8nhsmFCMyai00bOuACqu4";

  static const String secretKey =
      String.fromEnvironment('STRIPE_SECRET_KEY', defaultValue: '');
}