/// نموذج عملية Bulk Operation (عمليات مجمعة)
class BulkOperationModel {
  final String id;
  final String operationType; // 'update', 'delete', 'activate', 'deactivate', 'export', 'import'
  final String entityType; // 'products', 'orders', etc.
  final int totalItems;
  final int processedItems;
  final int successCount;
  final int failureCount;
  final String status; // 'pending', 'processing', 'completed', 'failed'
  final Map<String, dynamic>? parameters; // Parameters for the operation
  final List<Map<String, dynamic>>? errors; // List of errors if any
  final DateTime createdAt;
  final DateTime? completedAt;

  BulkOperationModel({
    required this.id,
    required this.operationType,
    required this.entityType,
    required this.totalItems,
    this.processedItems = 0,
    this.successCount = 0,
    this.failureCount = 0,
    this.status = 'pending',
    this.parameters,
    this.errors,
    required this.createdAt,
    this.completedAt,
  });

  factory BulkOperationModel.fromJson(Map<String, dynamic> json) {
    return BulkOperationModel(
      id: json['id'] as String,
      operationType: json['operation_type'] as String,
      entityType: json['entity_type'] as String,
      totalItems: json['total_items'] as int,
      processedItems: json['processed_items'] as int? ?? 0,
      successCount: json['success_count'] as int? ?? 0,
      failureCount: json['failure_count'] as int? ?? 0,
      status: json['status'] as String? ?? 'pending',
      parameters: json['parameters'] as Map<String, dynamic>?,
      errors: json['errors'] != null
          ? List<Map<String, dynamic>>.from(json['errors'])
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'operation_type': operationType,
      'entity_type': entityType,
      'total_items': totalItems,
      'processed_items': processedItems,
      'success_count': successCount,
      'failure_count': failureCount,
      'status': status,
      if (parameters != null) 'parameters': parameters,
      if (errors != null) 'errors': errors,
      'created_at': createdAt.toIso8601String(),
      if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
    };
  }

  double get progressPercentage {
    if (totalItems == 0) return 0.0;
    return (processedItems / totalItems) * 100;
  }
}

/// نموذج Bulk Operation Request
class BulkOperationRequest {
  final String operationType;
  final List<String> itemIds;
  final Map<String, dynamic>? updateData; // For update operations
  final Map<String, dynamic>? parameters; // Additional parameters

  BulkOperationRequest({
    required this.operationType,
    required this.itemIds,
    this.updateData,
    this.parameters,
  });

  Map<String, dynamic> toJson() {
    return {
      'operation_type': operationType,
      'item_ids': itemIds,
      if (updateData != null) 'update_data': updateData,
      if (parameters != null) 'parameters': parameters,
    };
  }
}

