import 'package:campus_flutter/base/enums/calendar_event_type.dart';
import 'package:campus_flutter/searchComponent/model/comparison_token.dart';
import 'package:campus_flutter/searchComponent/protocols/searchable.dart';
import 'package:campus_flutter/base/extensions/context.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'calendar_event.g.dart';

@JsonSerializable()
class CalendarEvent extends Searchable {
  @JsonKey(name: "nr")
  final String id;
  final String status;
  final String? url;
  final String title;
  final String? description;
  @JsonKey(name: "dtstart")
  final DateTime startDate;
  @JsonKey(name: "dtend")
  final DateTime endDate;
  final String? location;

  Duration get duration {
    return endDate.difference(startDate);
  }

  String? get lvNr {
    return url?.split("LvNr=").last;
  }

  String get timePeriod {
    return "${DateFormat.Hm().format(startDate)} - ${DateFormat.Hm().format(endDate)}";
  }

  String timeDatePeriod(BuildContext context) {
    final start =
        DateFormat("EE, dd.MM.yyyy, HH:mm", context.localizations.localeName)
            .format(startDate);
    final end =
        DateFormat("HH:mm", context.localizations.localeName).format(endDate);
    return "$start - $end";
  }

  bool get isCanceled {
    return status == "CANCEL";
  }

  CalendarEventType get type {
    if (isCanceled) {
      return CalendarEventType.canceled;
    } else if (title.endsWith("VO") ||
        title.endsWith("VU") ||
        title.endsWith("VI")) {
      return CalendarEventType.lecture;
    } else if (title.endsWith("UE")) {
      return CalendarEventType.exercise;
    } else {
      return CalendarEventType.other;
    }
  }

  Color getEventColor(BuildContext context) {
    switch (type) {
      case CalendarEventType.canceled:
        return Colors.red;
      case CalendarEventType.lecture:
        return Colors.green;
      case CalendarEventType.exercise:
        return Colors.orange;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<ComparisonToken> get comparisonTokens => [
        ComparisonToken(value: title),
        if (location != null) ComparisonToken(value: location!),
      ];

  CalendarEvent({
    required this.id,
    required this.status,
    this.url,
    required this.title,
    this.description,
    required this.startDate,
    required this.endDate,
    this.location,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarEventToJson(this);
}

@JsonSerializable()
class CalendarEventsData {
  final CalendarEvents? events;

  CalendarEventsData({required this.events});

  factory CalendarEventsData.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventsDataFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarEventsDataToJson(this);
}

@JsonSerializable()
class CalendarEvents {
  final List<CalendarEvent> event;

  CalendarEvents({required this.event});

  factory CalendarEvents.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventsFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarEventsToJson(this);
}
