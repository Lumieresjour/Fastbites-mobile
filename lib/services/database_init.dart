// Conditional import: use IO version on desktop, web version on web
export 'database_init_io.dart' if (dart.library.html) 'database_init_web.dart';
