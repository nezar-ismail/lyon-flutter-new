
import 'dart:convert';

List<GetProjectNameModel> welcomeFromJson(String str) => List<GetProjectNameModel>.from(json.decode(str).map((x) => GetProjectNameModel.fromJson(x)));

String welcomeToJson(List<GetProjectNameModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetProjectNameModel {
    GetProjectNameModel({
        this.projectName,
    });

    String? projectName;

    factory GetProjectNameModel.fromJson(Map<String, dynamic> json) => GetProjectNameModel(
        projectName: json["project_name"],
    );

    Map<String, dynamic> toJson() => {
        "project_name": projectName,
    };
}
