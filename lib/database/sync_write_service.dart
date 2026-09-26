import 'app_database.dart';
import 'sync_foundation.dart';

/// Central entry point for recording application changes for synchronization.
///
/// IMPORTANT:
/// This service does not replace the existing accounting services yet.
/// During Phase 2 we will connect the existing write operations to this
/// service one workflow at a time.
class SyncWriteService {
  SyncWriteService._();

  /// Record creation of a logical business transaction.
  static Future<String> recordCreate(
    AppDatabase db, {
    required String entity,
    required String recordId,
    required Map<String, dynamic> data,
    String? username,
  }) async {
    return SyncFoundation.enqueueChange(
      db,
      entity: entity,
      recordId: recordId,
      operation: 'CREATE',
      payload: data,
      actorUsername: username,
    );
  }

  /// Record an update.
  static Future<String> recordUpdate(
    AppDatabase db, {
    required String entity,
    required String recordId,
    required Map<String, dynamic> data,
    String? username,
  }) async {
    return SyncFoundation.enqueueChange(
      db,
      entity: entity,
      recordId: recordId,
      operation: 'UPDATE',
      payload: data,
      actorUsername: username,
    );
  }

  /// Record a deletion.
  ///
  /// The actual deletion remains the responsibility of the existing
  /// accounting workflow. This records the fact that the record disappeared
  /// so a future synchronization transport can propagate it.
  static Future<String> recordDelete(
    AppDatabase db, {
    required String entity,
    required String recordId,
    Map<String, dynamic> data = const <String, dynamic>{},
    String? username,
  }) async {
    return SyncFoundation.enqueueChange(
      db,
      entity: entity,
      recordId: recordId,
      operation: 'DELETE',
      payload: data,
      actorUsername: username,
    );
  }

  /// Record a complete logical transaction bundle.
  ///
  /// This is particularly useful for operations such as:
  ///
  /// household payment
  /// + payment allocations
  /// + opening balance allocations
  ///
  /// or:
  ///
  /// concession
  /// + concession allocations
  ///
  /// We want another device to receive the business transaction as one
  /// coherent synchronization unit.
  static Future<String> recordBundle(
    AppDatabase db, {
    required String entity,
    required String recordId,
    required Map<String, dynamic> bundle,
    String? username,
    String operation = 'CREATE',
  }) async {
    return SyncFoundation.enqueueChange(
      db,
      entity: entity,
      recordId: recordId,
      operation: operation,
      payload: bundle,
      actorUsername: username,
    );
  }

  /// Returns changes currently waiting for a transport.
  static Future<List<Map<String, dynamic>>> pending(
    AppDatabase db, {
    int limit = 100,
  }) {
    return SyncFoundation.getPendingChanges(
      db,
      limit: limit,
    );
  }

  /// Mark a locally queued change as successfully delivered to a remote
  /// synchronization transport.
  static Future<void> markSynced(
    AppDatabase db,
    String changeId,
  ) {
    return SyncFoundation.markUploaded(
      db,
      changeId,
    );
  }

  /// Record a failed synchronization attempt.
  static Future<void> markError(
    AppDatabase db, {
    required String changeId,
    required String error,
  }) {
    return SyncFoundation.markFailed(
      db,
      changeId: changeId,
      error: error,
    );
  }
}