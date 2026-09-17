import 'package:intl/intl.dart';
import '../../localization/t.dart';

/// One checkpoint in the order timeline.
class TrackingStageModel {
  const TrackingStageModel({
    required this.key,
    required this.label,
    required this.done,
    this.at,
  });

  final String key;
  final String label;
  final bool done;
  final String? at;

  factory TrackingStageModel.fromJson(Map<String, dynamic> json) {
    final at = json['at']?.toString();

    return TrackingStageModel(
      key: json['key']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      done: json['done'] == true,
      at: (at == null || at.isEmpty) ? null : at,
    );
  }

  DateTime? get time => at == null ? null : DateTime.tryParse(at!)?.toLocal();

  /// e.g. "14 Sep".
  String get dateLabel => time == null ? '' : DateFormat('dd MMM').format(time!);

  /// e.g. "14 Sep 2026, 10:22 AM", or "Pending".
  String get dateTimeLabel => time == null ? t('common.pending') : DateFormat('dd MMM yyyy, hh:mm a').format(time!);
}

/// Courier details attached to a dispatch, when one exists.
class CourierModel {
  const CourierModel({this.name, this.trackingNo, this.trackingUrl, this.status});

  final String? name;
  final String? trackingNo;
  final String? trackingUrl;
  final String? status;

  bool get hasTracking => (trackingNo ?? '').isNotEmpty;

  bool get hasLink => (trackingUrl ?? '').isNotEmpty;

  factory CourierModel.fromJson(Map<String, dynamic> json) {
    return CourierModel(
      name: json['name']?.toString(),
      trackingNo: json['tracking_no']?.toString(),
      trackingUrl: json['tracking_url']?.toString(),
      status: json['status']?.toString(),
    );
  }
}

/// Full response of the order tracking endpoint.
class OrderTrackingModel {
  const OrderTrackingModel({
    required this.orderNo,
    required this.status,
    required this.stages,
    this.courier,
    this.total = 0,
    this.createdAt = '',
  });

  final String orderNo;
  final String status;
  final List<TrackingStageModel> stages;
  final CourierModel? courier;
  final double total;
  final String createdAt;

  bool get isCancelled => status == 'cancelled' || status == 'rejected';

  /// Index of the furthest completed stage, which the stepper highlights.
  int get currentStage {
    final lastDone = stages.lastIndexWhere((stage) => stage.done);
    return lastDone < 0 ? 0 : lastDone;
  }

  /// The most recent completed stage, or null before the first update.
  TrackingStageModel? get lastDoneStage {
    final index = stages.lastIndexWhere((stage) => stage.done);
    return index < 0 ? null : stages[index];
  }

  /// e.g. "14 Sep 2026".
  String get placedLabel {
    final parsed = DateTime.tryParse(createdAt);
    return parsed == null ? '' : DateFormat('dd MMM yyyy').format(parsed.toLocal());
  }

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) {
    final order = json['order'];
    final orderMap = order is Map<String, dynamic> ? order : const <String, dynamic>{};
    final courier = json['courier'];
    final stages = json['stages'];

    return OrderTrackingModel(
      orderNo: orderMap['order_no']?.toString() ?? '',
      status: orderMap['status']?.toString() ?? '',
      total: double.tryParse(orderMap['grand_total']?.toString() ?? '') ?? 0,
      createdAt: orderMap['created_at']?.toString() ?? '',
      stages: stages is List
          ? stages
              .whereType<Map<String, dynamic>>()
              .map(TrackingStageModel.fromJson)
              .toList()
          : const <TrackingStageModel>[],
      courier: courier is Map<String, dynamic> ? CourierModel.fromJson(courier) : null,
    );
  }
}
