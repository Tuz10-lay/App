import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1, // number of method call to be displayed
    errorMethodCount: 10, // number of method call if stackstrace is provided
    lineLength: 100, // width of the output
    colors: true, // make the log messages colorful
    printEmojis: true, // print additional emoji for each log message
  ),
);
