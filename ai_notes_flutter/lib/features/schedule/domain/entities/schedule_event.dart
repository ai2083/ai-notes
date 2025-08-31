import 'package:equatable/equatable.dart';

/// 日程事件类型枚举
enum ScheduleEventType {
  anniversary,    // 纪念日
  meeting,       // 会议
  appointment,   // 约定
  task,          // 任务
  activity,      // 活动
}

/// 重复类型枚举
enum RecurrenceType {
  daily,     // 每日
  weekly,    // 每周
  monthly,   // 每月
  yearly,    // 每年
  custom,    // 自定义
}

/// 提醒类型枚举
enum ReminderType {
  notification,  // 通知
  email,        // 邮件
  sms,          // 短信
}

/// 事件状态枚举
enum ScheduleEventStatus {
  active,    // 活跃
  cancelled, // 已取消
  completed, // 已完成
  deleted,   // 已删除
}

/// 日程事件实体
class ScheduleEvent extends Equatable {
  /// 事件ID
  final String id;
  
  /// 用户ID
  final String userId;
  
  /// 事件标题
  final String title;
  
  /// 事件描述
  final String? description;
  
  /// 事件类型
  final ScheduleEventType type;
  
  /// 开始时间
  final DateTime startTime;
  
  /// 结束时间
  final DateTime? endTime;
  
  /// 是否为全天事件
  final bool isAllDay;
  
  /// 地点
  final String? location;
  
  /// 参与者
  final List<String> attendees;
  
  /// 重复规则
  final ScheduleRecurrence? recurrence;
  
  /// 提醒设置
  final List<ScheduleReminder> reminders;
  
  /// 事件状态
  final ScheduleEventStatus status;
  
  /// 元数据
  final Map<String, dynamic>? metadata;
  
  /// 颜色
  final String? color;
  
  /// 分类ID
  final String? categoryId;
  
  /// 标签
  final List<String> tags;
  
  /// 创建时间
  final DateTime createdAt;
  
  /// 更新时间
  final DateTime updatedAt;
  
  /// 删除时间
  final DateTime? deletedAt;

  const ScheduleEvent({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.type,
    required this.startTime,
    this.endTime,
    this.isAllDay = false,
    this.location,
    this.attendees = const [],
    this.recurrence,
    this.reminders = const [],
    this.status = ScheduleEventStatus.active,
    this.metadata,
    this.color,
    this.categoryId,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  /// 复制并修改部分字段
  ScheduleEvent copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    ScheduleEventType? type,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAllDay,
    String? location,
    List<String>? attendees,
    ScheduleRecurrence? recurrence,
    List<ScheduleReminder>? reminders,
    ScheduleEventStatus? status,
    Map<String, dynamic>? metadata,
    String? color,
    String? categoryId,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return ScheduleEvent(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAllDay: isAllDay ?? this.isAllDay,
      location: location ?? this.location,
      attendees: attendees ?? this.attendees,
      recurrence: recurrence ?? this.recurrence,
      reminders: reminders ?? this.reminders,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      color: color ?? this.color,
      categoryId: categoryId ?? this.categoryId,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'type': type.index,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'isAllDay': isAllDay,
      'location': location,
      'attendees': attendees,
      'recurrence': recurrence?.toJson(),
      'reminders': reminders.map((r) => r.toJson()).toList(),
      'status': status.index,
      'metadata': metadata,
      'color': color,
      'categoryId': categoryId,
      'tags': tags,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
    };
  }

  /// 从JSON创建
  factory ScheduleEvent.fromJson(Map<String, dynamic> json) {
    return ScheduleEvent(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      type: ScheduleEventType.values[json['type'] ?? 0],
      startTime: DateTime.fromMillisecondsSinceEpoch(json['startTime'] ?? 0),
      endTime: json['endTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['endTime'])
          : null,
      isAllDay: json['isAllDay'] ?? false,
      location: json['location'],
      attendees: List<String>.from(json['attendees'] ?? []),
      recurrence: json['recurrence'] != null 
          ? ScheduleRecurrence.fromJson(json['recurrence'])
          : null,
      reminders: (json['reminders'] as List?)
          ?.map((r) => ScheduleReminder.fromJson(r))
          .toList() ?? [],
      status: ScheduleEventStatus.values[json['status'] ?? 0],
      metadata: json['metadata'],
      color: json['color'],
      categoryId: json['categoryId'],
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] ?? 0),
      deletedAt: json['deletedAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['deletedAt'])
          : null,
    );
  }

  /// 获取事件持续时间
  Duration get duration {
    if (endTime == null) return Duration.zero;
    return endTime!.difference(startTime);
  }

  /// 检查是否为今天的事件
  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(startTime.year, startTime.month, startTime.day);
    return eventDate == today;
  }

  /// 检查是否为过期事件
  bool get isOverdue {
    if (endTime != null) {
      return endTime!.isBefore(DateTime.now());
    }
    return startTime.isBefore(DateTime.now());
  }

  /// 检查是否为即将到来的事件（24小时内）
  bool get isUpcoming {
    final now = DateTime.now();
    final timeDiff = startTime.difference(now);
    return timeDiff.inHours >= 0 && timeDiff.inHours <= 24;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        type,
        startTime,
        endTime,
        isAllDay,
        location,
        attendees,
        recurrence,
        reminders,
        status,
        metadata,
        color,
        categoryId,
        tags,
        createdAt,
        updatedAt,
        deletedAt,
      ];

  @override
  String toString() {
    return 'ScheduleEvent(id: $id, title: $title, type: $type, startTime: $startTime)';
  }
}

/// 重复规则实体
class ScheduleRecurrence extends Equatable {
  /// 重复类型
  final RecurrenceType type;
  
  /// 间隔
  final int interval;
  
  /// 星期几（1-7，1为周一）
  final List<int>? daysOfWeek;
  
  /// 每月的第几天
  final List<int>? daysOfMonth;
  
  /// 每年的第几月
  final List<int>? monthsOfYear;
  
  /// 结束日期
  final DateTime? endDate;
  
  /// 重复次数
  final int? occurrences;

  const ScheduleRecurrence({
    required this.type,
    this.interval = 1,
    this.daysOfWeek,
    this.daysOfMonth,
    this.monthsOfYear,
    this.endDate,
    this.occurrences,
  });

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
      'interval': interval,
      'daysOfWeek': daysOfWeek,
      'daysOfMonth': daysOfMonth,
      'monthsOfYear': monthsOfYear,
      'endDate': endDate?.millisecondsSinceEpoch,
      'occurrences': occurrences,
    };
  }

  /// 从JSON创建
  factory ScheduleRecurrence.fromJson(Map<String, dynamic> json) {
    return ScheduleRecurrence(
      type: RecurrenceType.values[json['type'] ?? 0],
      interval: json['interval'] ?? 1,
      daysOfWeek: json['daysOfWeek'] != null 
          ? List<int>.from(json['daysOfWeek'])
          : null,
      daysOfMonth: json['daysOfMonth'] != null 
          ? List<int>.from(json['daysOfMonth'])
          : null,
      monthsOfYear: json['monthsOfYear'] != null 
          ? List<int>.from(json['monthsOfYear'])
          : null,
      endDate: json['endDate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['endDate'])
          : null,
      occurrences: json['occurrences'],
    );
  }

  @override
  List<Object?> get props => [
        type,
        interval,
        daysOfWeek,
        daysOfMonth,
        monthsOfYear,
        endDate,
        occurrences,
      ];
}

/// 提醒实体
class ScheduleReminder extends Equatable {
  /// 提醒ID
  final String id;
  
  /// 提醒类型
  final ReminderType type;
  
  /// 提前时间
  final Duration offsetBefore;
  
  /// 是否启用
  final bool isEnabled;

  const ScheduleReminder({
    required this.id,
    required this.type,
    required this.offsetBefore,
    this.isEnabled = true,
  });

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'offsetBefore': offsetBefore.inMilliseconds,
      'isEnabled': isEnabled,
    };
  }

  /// 从JSON创建
  factory ScheduleReminder.fromJson(Map<String, dynamic> json) {
    return ScheduleReminder(
      id: json['id'] ?? '',
      type: ReminderType.values[json['type'] ?? 0],
      offsetBefore: Duration(milliseconds: json['offsetBefore'] ?? 0),
      isEnabled: json['isEnabled'] ?? true,
    );
  }

  @override
  List<Object?> get props => [id, type, offsetBefore, isEnabled];
}
