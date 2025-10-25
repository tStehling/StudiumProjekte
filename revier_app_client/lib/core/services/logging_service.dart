import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// A clean logging service using the logger package
class LoggingService {
  static final LoggingService _instance = LoggingService._internal();

  /// Singleton instance
  factory LoggingService() => _instance;
  LoggingService._internal();

  /// Get the singleton instance
  static LoggingService get instance => _instance;

  /// The logger configuration
  late final Logger _logger;

  /// Initialize the logging service
  void initialize({bool includeTimestamps = true, bool writeToFile = false}) {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0, // Hide method count
        errorMethodCount: 5, // Show methods in stack traces for errors
        lineLength: 120, // Longer line length for better readability
        colors: true, // Colorful logs in console
        printEmojis: true, // Show emojis for log levels
        printTime: includeTimestamps, // Include timestamps if requested
      ),
      // Use appropriate log level based on debug mode
      level: kDebugMode ? Level.trace : Level.info,
    );

    // Log initialization
    _logger.i(
        '🚀 Logging service initialized in ${kDebugMode ? 'DEBUG' : 'PRODUCTION'} mode');
  }

  /// Get a logger with a class name prefix for better tracing
  ClassNameLogger getLogger(String className) {
    return ClassNameLogger(_logger, className);
  }
}

/// Custom logger wrapper that prefixes messages with the class name
class ClassNameLogger {
  final Logger _baseLogger;
  final String _className;

  ClassNameLogger(this._baseLogger, this._className);

  void v(dynamic message, {Object? error, StackTrace? stackTrace}) {
    _log(Level.trace, message, error, stackTrace);
  }

  void d(dynamic message, {Object? error, StackTrace? stackTrace}) {
    _log(Level.debug, message, error, stackTrace);
  }

  void i(dynamic message, {Object? error, StackTrace? stackTrace}) {
    _log(Level.info, message, error, stackTrace);
  }

  void w(dynamic message, {Object? error, StackTrace? stackTrace}) {
    _log(Level.warning, message, error, stackTrace);
  }

  void e(dynamic message, {Object? error, StackTrace? stackTrace}) {
    _log(Level.error, message, error, stackTrace);
  }

  void wtf(dynamic message, {Object? error, StackTrace? stackTrace}) {
    _log(Level.fatal, message, error, stackTrace);
  }

  // Convenience aliases for more standard method names
  void trace(dynamic message, {Object? error, StackTrace? stackTrace}) =>
      v(message, error: error, stackTrace: stackTrace);
  void debug(dynamic message, {Object? error, StackTrace? stackTrace}) =>
      d(message, error: error, stackTrace: stackTrace);
  void info(dynamic message, {Object? error, StackTrace? stackTrace}) =>
      i(message, error: error, stackTrace: stackTrace);
  void warning(dynamic message, {Object? error, StackTrace? stackTrace}) =>
      w(message, error: error, stackTrace: stackTrace);
  void error(dynamic message, {Object? error, StackTrace? stackTrace}) =>
      e(message, error: error, stackTrace: stackTrace);
  void fatal(dynamic message, {Object? error, StackTrace? stackTrace}) =>
      wtf(message, error: error, stackTrace: stackTrace);

  // For compatibility with Flutter logging
  void fine(dynamic message, {Object? error, StackTrace? stackTrace}) =>
      d(message, error: error, stackTrace: stackTrace);

  // For compatibility with Flutter logging
  void severe(dynamic message, {Object? error, StackTrace? stackTrace}) =>
      fatal(message, error: error, stackTrace: stackTrace);

  // For compatibility with Flutter logging
  void warn(dynamic message, {Object? error, StackTrace? stackTrace}) =>
      w(message, error: error, stackTrace: stackTrace);

  // Internal helper to add class name prefix
  void _log(
      Level level, dynamic message, Object? error, StackTrace? stackTrace) {
    final formattedMessage = '[$_className] $message';
    _baseLogger.log(level, formattedMessage,
        error: error, stackTrace: stackTrace);
  }
}

final loggingService = LoggingService.instance;
