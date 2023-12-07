import 'package:json_annotation/json_annotation.dart';

part 'organisation.g.dart';

@JsonSerializable()
class Organisation {
  @JsonKey(name: "org")
  final String? name;
  @JsonKey(name: "kennung")
  final String? id;
  @JsonKey(name: "org_nr")
  final String? number;
  @JsonKey(name: "titel")
  final String? title;
  @JsonKey(name: "beschreibung")
  final String? description;

  Organisation({this.name, this.id, this.number, this.title, this.description});

  factory Organisation.fromJson(Map<String, dynamic> json) =>
      _$OrganisationFromJson(json);

  Map<String, dynamic> toJson() => _$OrganisationToJson(this);
}
