/// API Configuration
/// إعدادات الاتصال بالـ API
library;

class ApiConfig {
  /// Base URL for the Worker API
  static const String baseUrl =
      'https://misty-mode-b68b.baharista1.workers.dev';

  /// Supabase URL
  static const String supabaseUrl = 'https://sirqidofuvphqcxqchyc.supabase.co';

  /// Supabase Anon Key
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNpcnFpZG9mdXZwaHFjeHFjaHljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIzMDE2MTAsImV4cCI6MjA0Nzg3NzYxMH0.iU1Xfk5zMvluExhxRYl0Xv0yXqxj7o8d0yGhbDEEPDs';

  /// Request timeout duration
  static const Duration requestTimeout = Duration(seconds: 30);

  /// Long request timeout (for AI generation)
  static const Duration longRequestTimeout = Duration(minutes: 2);

  /// Enable debug logging
  static const bool enableDebugLogging = true;

  // =====================================================
  // Revenue Engine Endpoints
  // =====================================================

  static String get pricingQuoteUrl => '$baseUrl/api/pricing/pricing/quote';
  static String get templatesUrl => '$baseUrl/secure/revenue/templates';
  static String get projectsUrl => '$baseUrl/secure/revenue/projects';

  static String projectUrl(String id) => '$baseUrl/secure/revenue/projects/$id';
  static String projectPayUrl(String id) =>
      '$baseUrl/secure/revenue/projects/$id/pay';
  static String projectExecuteStepUrl(String id) =>
      '$baseUrl/secure/revenue/projects/$id/step/execute';
  static String projectApproveUrl(String id) =>
      '$baseUrl/secure/revenue/projects/$id/approve';
  static String projectReviseUrl(String id) =>
      '$baseUrl/secure/revenue/projects/$id/revise';
}
