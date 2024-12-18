class InternalException implements Exception {
  final String message;

  InternalException(this.message);

  @override
  /// Returns a string representation of the [InternalException].
  ///
  /// This string is used when the exception is printed to the console,
  /// and is also used in the `toString` method of the [Exception] class.
  ///
  /// The format of the string is "InternalException: <message>",
  /// where <message> is the value of the [message] property.
  String toString() {
    return 'InternalException: $message';
  }
}