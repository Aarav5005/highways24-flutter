import 'dart:async';
import 'dart:math';
import '../logging/app_logger.dart';

enum OperationStatus {
  pending,
  syncing,
  completed,
  failed,
}

class PendingOperation {
  final String id;
  final String type; // 'PlaceOrder', 'StartTrip', 'SubmitBreakdownRequest', 'SOSActivation'
  final String idempotencyKey;
  final String correlationId;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final DateTime? lastAttemptAt;
  final String? lastError;
  final int retryCount;
  final OperationStatus status;

  PendingOperation({
    required this.id,
    required this.type,
    required this.idempotencyKey,
    required this.correlationId,
    required this.payload,
    required this.createdAt,
    this.lastAttemptAt,
    this.lastError,
    this.retryCount = 0,
    this.status = OperationStatus.pending,
  });

  // Exponential Backoff Delay Calculation (5s, 15s, 30s, 60s, 300s)
  Duration get nextRetryDelay {
    final backoffSeconds = min(300, 5 * pow(2, retryCount).toInt());
    return Duration(seconds: backoffSeconds);
  }

  bool get shouldAttempt {
    if (status != OperationStatus.pending) return false;
    if (lastAttemptAt == null) return true;
    return DateTime.now().difference(lastAttemptAt!) >= nextRetryDelay;
  }

  PendingOperation copyWith({
    int? retryCount,
    OperationStatus? status,
    DateTime? lastAttemptAt,
    String? lastError,
  }) {
    return PendingOperation(
      id: id,
      type: type,
      idempotencyKey: idempotencyKey,
      correlationId: correlationId,
      payload: payload,
      createdAt: createdAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      lastError: lastError ?? this.lastError,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
    );
  }
}

class OfflineSyncQueue {
  final List<PendingOperation> _queue = [];

  List<PendingOperation> get pendingOperations =>
      _queue.where((op) => op.shouldAttempt).toList();

  int get totalQueued => _queue.length;
  int get totalCompleted => _queue.where((o) => o.status == OperationStatus.completed).length;
  int get totalFailed => _queue.where((o) => o.status == OperationStatus.failed).length;

  void enqueue(String type, Map<String, dynamic> payload) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final op = PendingOperation(
      id: 'op_$timestamp',
      type: type,
      idempotencyKey: 'idem_$timestamp',
      correlationId: 'corr_$timestamp',
      payload: payload,
      createdAt: DateTime.now(),
    );
    _queue.add(op);
    AppLogger.info('Enqueued offline operation: [${op.type}] (Idempotency: ${op.idempotencyKey})', 'SYNC');
  }

  Future<void> processQueue(Future<bool> Function(PendingOperation op) syncHandler) async {
    final toProcess = List<PendingOperation>.from(pendingOperations);

    for (var op in toProcess) {
      final index = _queue.indexWhere((o) => o.id == op.id);
      if (index >= 0) {
        _queue[index] = op.copyWith(
          status: OperationStatus.syncing,
          lastAttemptAt: DateTime.now(),
        );

        try {
          bool success = await syncHandler(op);
          if (success) {
            _queue[index] = op.copyWith(status: OperationStatus.completed);
            AppLogger.info('Successfully synced operation: [${op.type}] (${op.idempotencyKey})', 'SYNC');
          } else {
            final newRetry = op.retryCount + 1;
            if (newRetry >= 5) {
              _queue[index] = op.copyWith(
                retryCount: newRetry,
                status: OperationStatus.failed,
                lastError: 'Max retry limit reached',
              );
            } else {
              _queue[index] = op.copyWith(
                retryCount: newRetry,
                status: OperationStatus.pending,
                lastError: 'Server sync failed',
              );
            }
          }
        } catch (e) {
          final newRetry = op.retryCount + 1;
          _queue[index] = op.copyWith(
            retryCount: newRetry,
            status: OperationStatus.pending,
            lastError: e.toString(),
          );
        }
      }
    }
  }

  void clearCompleted() {
    _queue.removeWhere((op) => op.status == OperationStatus.completed);
  }
}
