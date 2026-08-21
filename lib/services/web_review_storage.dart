// Conditional export based on platform
export 'web_review_storage_stub.dart'
    if (dart.library.html) 'web_review_storage_web.dart';

