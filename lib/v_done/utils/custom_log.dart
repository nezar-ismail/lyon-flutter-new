import 'dart:developer';

/// Logs an error message with a specific name for the Lyon-rent application.
/// 
/// The [error] parameter is the error message to be logged.
/// The log entry is tagged with the name "[Lyon-rent: Error]" for identification.
void logError(String error) {
  log(error, name: "[Lyon-rent: Error]");
}


/// Logs an informational message with a specific name for the Lyon-rent application.
/// 
/// The [info] parameter is the informational message to be logged.
/// The log entry is tagged with the name "[Lyon-rent: Info]" for identification.
void logInfo(String info) {
  log(info, name: "[Lyon-rent: Info]");
}

/// Logs a warning message with a specific name for the Lyon-rent application.
/// 
/// The [warning] parameter is the warning message to be logged.
/// The log entry is tagged with the name "[Lyon-rent: Warning]" for identification.
void logWarning(String warning) {
  log(warning, name: "[Lyon-rent: Warning]");
}

/// Logs a debug message with a specific name for the Lyon-rent application.
/// 
/// The [debug] parameter is the debug message to be logged.
/// The log entry is tagged with the name "[Lyon-rent: Debug]" for identification.
void logDebug(String debug, Set set) {
  log(debug, name: "[Lyon-rent: Debug]");
}

extension LogExtension on String {
  /// Logs the string as an error message with a specific name for the Lyon-rent application.
  ///
  /// The log entry is tagged with the name "[Lyon-rent: Error]" for identification.
  void logError() {
    log(this, name: "[Lyon-rent: Error]");
  }

  /// Logs the string as an informational message with a specific name for the Lyon-rent application.
  ///
  /// The log entry is tagged with the name "[Lyon-rent: Info]" for identification.
  void logInfo() {
    log(this, name: "[Lyon-rent: Info]");
  }

  /// Logs the string as a warning message with a specific name for the Lyon-rent application.
  ///
  /// The log entry is tagged with the name "[Lyon-rent: Warning]" for identification.
  void logWarning() {
    log(this, name: "[Lyon-rent: Warning]");
  }

  /// Logs the string as a debug message with a specific name for the Lyon-rent application.
  ///
  /// The log entry is tagged with the name "[Lyon-rent: Debug]" for identification.
  void logDebug() {
    log(this, name: "[Lyon-rent: Debug]");
  }
}