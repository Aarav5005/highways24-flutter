import 'dart:async';
import 'dart:math';
import '../logging/app_logger.dart';

enum OperationStatus {
  pending,
  syncing,
  completed,
  failed,
  deadLettered,
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

  // Exponential Backoff Delay with Jitter (5s ± jitter ... 300s ± jitter)
  Duration get nextRetryDelay {
    final baseSeconds = min(300, 5 * pow(2, retryCount).toInt());
    final jitter = Random().nextInt(5); // 0..4 seconds jitter
    return Duration(seconds: baseSeconds + jitter);
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
  final List<PendingOperation> _deadLetterQueue = [];

  List<PendingOperation> get pendingOperations =>
      _queue.where((op) => op.shouldAttempt).toList();

  List<PendingOperation> get deadLetterQueue => List.unmodifiable(_deadLetterQueue);

  int get totalQueued => _queue.length;
  int get totalCompleted => _queue.where((o) => o.status == OperationStatus.completed).length;
  int get totalFailed => _queue.where((o) => o.status == OperationStatus.failed).length;
  int get totalDeadLettered => _deadLetterQueue.length;

  static String _generateUuid() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    values[6] = (values[6] & 0x0f) | 0x40; // version 4
    values[8] = (values[8] & 0x3f) | 0x80; // variant 10
    return values.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  void enqueue(String type, Map<String, dynamic> payload) {
    final op = PendingOperation(
      id: 'op_${_generateUuid().substring(0, 8)}',
      type: type,
      idempotencyKey: 'idem_${_generateUuid()}',
      correlationId: 'corr_${_generateUuid()}',
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
              final deadLetterOp = op.copyWith(
                retryCount: newRetry,
                status: OperationStatus.deadLettered,
                lastError: 'Max retries exceeded. Moved to Dead Letter Queue.',
              );
              _queue.removeAt(index);
              _deadLetterQueue.add(deadLetterOp);
              AppLogger.warning('Operation moved to Dead Letter Queue: [${op.type}] (${op.idempotencyKey})', 'SYNC');
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
