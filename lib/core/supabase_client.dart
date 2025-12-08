// Supabase client is intentionally disabled in the Flutter client.
// Architecture: Flutter -> Worker (API Gateway) -> Supabase
// The Flutter application must NOT initialize or use supabaseClient directly.
// Any prior usage of supabaseClient must be replaced with ApiService calls.

/// initSupabase is a no-op on purpose. Do not initialize Supabase in the client.
Future<void> initSupabase() async {
  // Intentionally left blank. Using Supabase directly from Flutter is prohibited
  // to avoid leaking secrets or bypassing the Worker API. Use ApiService instead.
  return;
}

/// Accessing supabaseClient directly will throw — replace with ApiService.
Never get supabaseClient => throw UnsupportedError(
  'Do not use supabaseClient in Flutter. Use ApiService instead.',
);
