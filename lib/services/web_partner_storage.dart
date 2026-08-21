// Conditional export based on platform
export 'web_partner_storage_stub.dart'
    if (dart.library.html) 'web_partner_storage_web.dart';
