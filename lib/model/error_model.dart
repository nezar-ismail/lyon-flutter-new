import 'dart:convert';

ErrorCheck welcomeFromJson(String str) => ErrorCheck.fromJson(json.decode(str));

String welcomeToJson(ErrorCheck data) => json.encode(data.toJson());

class ErrorCheck {
    ErrorCheck({
        this.status,
        this.error,
    });

    int? status;
    String? error;

    factory ErrorCheck.fromJson(Map<String, dynamic> json) => ErrorCheck(
        status: json["status"],
        error: json["error"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
    };
}
