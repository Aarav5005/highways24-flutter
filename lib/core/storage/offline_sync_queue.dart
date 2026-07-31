import 'dart:async';
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
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final int retryCount;
  final OperationStatus status;

  PendingOperation({
    required this.id,
    required this.type,
    required this.payload,
    required this.createdAt,
    this.retryCount = 0,
    this.status = OperationStatus.pending,
  });

  PendingOperation copyWith({
    int? retryCount,
    OperationStatus? status,
  }) {
    return PendingOperation(
      id: id,
      type: type,
      payload: payload,
      createdAt: createdAt,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
    );
  }
}

class OfflineSyncQueue {
  final List<PendingOperation> _queue = [];

  List<PendingOperation> get pendingOperations =>
      _queue.where((op) => op.status == OperationStatus.pending).toList();

  void enqueue(String type, Map<String, dynamic> payload) {
    final op = PendingOperation(
      id: 'op_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      payload: payload,
      createdAt: DateTime.now(),
    );
    _queue.add(op);
    AppLogger.info('Enqueued offline operation: [${op.type}] (${op.id})', 'SYNC');
  }

  Future<void> processQueue(Future<bool> Function(PendingOperation op) syncHandler) async {
    final toProcess = List<PendingOperation>.from(pendingOperations);

    for (var op in toProcess) {
      final index = _queue.indexWhere((o) => o.id == op.id);
      if (index >= 0) {
        _queue[index] = op.copyWith(status: OperationStatus.syncing);

        try {
          bool success = await syncHandler(op);
          if (success) {
            _queue[index] = op.copyWith(status: OperationStatus.completed);
            AppLogger.info('Successfully synced offline operation: [${op.type}]', 'SYNC');
          } else {
            final newRetry = op.retryCount + 1;
            if (newRetry >= 5) {
              _queue[index] = op.copyWith(retryCount: newRetry, status: OperationStatus.failed);
            } else {
              _queue[index] = op.copyWith(retryCount: newRetry, status: OperationStatus.pending);
            }
          }
        } catch (_) {
          final newRetry = op.retryCount + 1;
          _queue[index] = op.copyWith(retryCount: newRetry, status: OperationStatus.pending);
        }
      }
    }
  }

  void clearCompleted() {
    _queue.removeWhere((op) => op.status == OperationStatus.completed);
  }
}
