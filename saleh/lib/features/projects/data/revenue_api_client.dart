/// Revenue Engine API Client
/// العميل للتواصل مع Worker
library;

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../core/config/api_config.dart';
import 'revenue_models.dart';

// =====================================================
// API Client
// =====================================================

class RevenueApiClient {
  final String baseUrl;
  final String? authToken;

  RevenueApiClient({required this.baseUrl, this.authToken});

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (authToken != null) 'Authorization': 'Bearer $authToken',
  };

  // =====================================================
  // Pricing Endpoints
  // =====================================================

  /// Get pricing quote for a project configuration
  Future<PricingQuote> getPricingQuote(PricingQuoteRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/pricing/pricing/quote'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return PricingQuote.fromJson(json);
    } else {
      final error = jsonDecode(response.body);
      throw RevenueApiException(
        error['error'] ?? 'Failed to get pricing quote',
        statusCode: response.statusCode,
      );
    }
  }

  // =====================================================
  // Templates Endpoints
  // =====================================================

  /// Get all active templates
  Future<List<ProjectTemplate>> getTemplates({ProjectType? projectType}) async {
    var url = '$baseUrl/secure/revenue/templates';
    if (projectType != null) {
      url += '?projectType=${projectType.value}';
    }

    final response = await http.get(Uri.parse(url), headers: _headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final templates = json['templates'] as List<dynamic>;
      return templates.map((t) => ProjectTemplate.fromJson(t)).toList();
    } else {
      throw RevenueApiException(
        'Failed to load templates',
        statusCode: response.statusCode,
      );
    }
  }

  /// Get a specific template
  Future<ProjectTemplate> getTemplate(String templateId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/secure/revenue/templates/$templateId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return ProjectTemplate.fromJson(json['template']);
    } else {
      throw RevenueApiException(
        'Template not found',
        statusCode: response.statusCode,
      );
    }
  }

  // =====================================================
  // Projects CRUD
  // =====================================================

  /// Create a new project
  Future<ApiResponse<Project>> createProject(
    CreateProjectRequest request,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/revenue/projects/create'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    final json = jsonDecode(response.body);
    return ApiResponse.fromJson(json, (j) => Project.fromJson(j));
  }

  /// Get user's projects
  Future<List<Project>> getProjects({ProjectStatus? status}) async {
    var url = '$baseUrl/secure/revenue/projects';
    if (status != null) {
      url += '?status=${status.value}';
    }

    final response = await http.get(Uri.parse(url), headers: _headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final projects = json['projects'] as List<dynamic>;
      return projects.map((p) => Project.fromJson(p)).toList();
    } else {
      throw RevenueApiException(
        'Failed to load projects',
        statusCode: response.statusCode,
      );
    }
  }

  /// Get a specific project
  Future<Project> getProject(String projectId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/secure/revenue/projects/$projectId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Project.fromJson(json['project']);
    } else {
      throw RevenueApiException(
        'Project not found',
        statusCode: response.statusCode,
      );
    }
  }

  // =====================================================
  // Project Actions
  // =====================================================

  /// Confirm payment for a project
  Future<ApiResponse<Project>> confirmPayment(String projectId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/revenue/projects/$projectId/pay'),
      headers: _headers,
    );

    final json = jsonDecode(response.body);
    return ApiResponse.fromJson(json, (j) => Project.fromJson(j));
  }

  /// Execute a step in the project
  Future<ApiResponse<Project>> executeStep(
    String projectId, {
    required int stepIndex,
    String? value,
    bool forceRegenerate = false,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/revenue/projects/$projectId/step/execute'),
      headers: _headers,
      body: jsonEncode({
        'stepIndex': stepIndex,
        if (value != null) 'value': value,
        'forceRegenerate': forceRegenerate,
      }),
    );

    final json = jsonDecode(response.body);
    return ApiResponse.fromJson(json, (j) => Project.fromJson(j));
  }

  /// Approve the project
  Future<ApiResponse<Project>> approveProject(
    String projectId, {
    required bool finalApproval,
    String? feedback,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/revenue/projects/$projectId/approve'),
      headers: _headers,
      body: jsonEncode({
        'finalApproval': finalApproval,
        if (feedback != null) 'feedback': feedback,
      }),
    );

    final json = jsonDecode(response.body);
    return ApiResponse.fromJson(json, (j) => Project.fromJson(j));
  }

  /// Request revision
  Future<ApiResponse<Project>> requestRevision(
    String projectId, {
    int? stepIndex,
    required String notes,
    required bool isRegenerate,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/revenue/projects/$projectId/revise'),
      headers: _headers,
      body: jsonEncode({
        if (stepIndex != null) 'stepIndex': stepIndex,
        'notes': notes,
        'isRegenerate': isRegenerate,
      }),
    );

    final json = jsonDecode(response.body);
    return ApiResponse.fromJson(json, (j) => Project.fromJson(j));
  }
}

// =====================================================
// Exception
// =====================================================

class RevenueApiException implements Exception {
  final String message;
  final int? statusCode;

  RevenueApiException(this.message, {this.statusCode});

  @override
  String toString() => 'RevenueApiException: $message (status: $statusCode)';
}

// =====================================================
// Provider
// =====================================================

final revenueApiClientProvider = Provider<RevenueApiClient>((ref) {
  // TODO: Get auth token from auth provider
  const authToken = null;

  return RevenueApiClient(baseUrl: ApiConfig.baseUrl, authToken: authToken);
});

// Pricing quote provider with caching
final pricingQuoteProvider =
    FutureProvider.family<PricingQuote, PricingQuoteRequest>((
      ref,
      request,
    ) async {
      final client = ref.watch(revenueApiClientProvider);
      return client.getPricingQuote(request);
    });

// Templates provider
final templatesProvider = FutureProvider<List<ProjectTemplate>>((ref) async {
  final client = ref.watch(revenueApiClientProvider);
  return client.getTemplates();
});

final templatesByTypeProvider =
    FutureProvider.family<List<ProjectTemplate>, ProjectType>((
      ref,
      projectType,
    ) async {
      final client = ref.watch(revenueApiClientProvider);
      return client.getTemplates(projectType: projectType);
    });

// Projects provider
final userProjectsProvider = FutureProvider<List<Project>>((ref) async {
  final client = ref.watch(revenueApiClientProvider);
  return client.getProjects();
});

final projectByIdProvider = FutureProvider.family<Project, String>((
  ref,
  projectId,
) async {
  final client = ref.watch(revenueApiClientProvider);
  return client.getProject(projectId);
});
